-- PULSE v2 DATABASE DELTA. Dr Madhu's live client database praswrwxhdvtnlcevmtz.
-- NOT APPLIED. Waits for the King's yes. Read the delta table in the session first.
-- Four items. Each one is additive: nothing existing is dropped, renamed or changed in meaning.
-- Run DDL and DML as separate statements. No dollar-quoting inside function bodies.

-- ITEM 1. Which clinic a walk-in came to. One new column, empty for everyone today.
alter table public.desk_leads add column if not exists clinic text;

-- ITEM 2. The add-a-person function learns the clinic and hands back the new id.
-- Same checks as today (name, 10 digit phone, duplicate refusal). One extra optional parameter.
create or replace function public.desk_add_person(
  p_key text, p_name text, p_phone text, p_email text, p_source text, p_note text, p_assigned text,
  p_phone_alt text default null, p_age text default null, p_location text default null,
  p_marital text default null, p_lead_source text default null, p_came_for text default null,
  p_clinic text default null)
returns jsonb language plpgsql security definer set search_path to 'public' as '
declare v_phone text; v_email text; v_existing desk_leads%rowtype; v_id uuid;
begin
  if not desk_check_key(p_key) then raise exception ''not allowed''; end if;
  v_phone := nullif(regexp_replace(coalesce(p_phone,''''), ''[^0-9]'', '''', ''g''),'''');
  v_email := nullif(lower(trim(coalesce(p_email,''''))),'''');
  if coalesce(trim(p_name),'''') = '''' then return jsonb_build_object(''ok'', false, ''error'', ''Please enter a name.''); end if;
  if v_phone is null or length(v_phone) < 10 then return jsonb_build_object(''ok'', false, ''error'', ''Please enter a phone number of at least 10 digits.''); end if;
  if p_source not in (''Walk-in'',''Phone enquiry'',''Referral'') then return jsonb_build_object(''ok'', false, ''error'', ''Pick where this person came from.''); end if;
  select * into v_existing from desk_leads
   where right(regexp_replace(coalesce(phone,''''), ''[^0-9]'', '''', ''g''), 10) = right(v_phone, 10)
      or (v_email is not null and email = v_email) limit 1;
  if v_existing.id is not null then
    return jsonb_build_object(''ok'', false, ''duplicate'', true, ''id'', v_existing.id,
      ''error'', ''Already in the list as '' || coalesce(v_existing.name,''(no name)'') || '', from '' || v_existing.came_from || ''.'');
  end if;
  insert into desk_leads (email, name, phone, phone_alt, age, location, marital_status, lead_source, came_for,
                          came_from, first_seen, phase, status, note, assigned_to, status_updated_at, clinic)
  values (coalesce(v_email, v_phone || ''@no-email.local''), trim(p_name), v_phone,
          nullif(regexp_replace(coalesce(p_phone_alt,''''), ''[^0-9]'', '''', ''g''),''''),
          nullif(trim(coalesce(p_age,'''')),''''), nullif(trim(coalesce(p_location,'''')),''''),
          nullif(trim(coalesce(p_marital,'''')),''''), nullif(trim(coalesce(p_lead_source,'''')),''''),
          nullif(trim(coalesce(p_came_for,'''')),''''),
          p_source, now(), 1, ''p1_new'',
          nullif(trim(coalesce(p_note,'''')),''''), nullif(trim(coalesce(p_assigned,'''')),''''), now(),
          nullif(trim(coalesce(p_clinic,'''')),''''))
  returning id into v_id;
  return jsonb_build_object(''ok'', true, ''id'', v_id);
end;';

-- ITEM 3. Clinic sales. Money taken at the desk in cash, UPI or card, which the payment
-- gateways never see. One row per visit. Locked exactly like desk_leads: row security on
-- for this NEW table only, zero policies, nothing granted to anon or authenticated, so the
-- only way in is through the two key-checked functions below.
create table if not exists public.desk_visits (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid not null references public.desk_leads(id) on delete cascade,
  clinic text,
  visited_at timestamptz not null default now(),
  consult_amount numeric,
  medicine text,
  medicine_amount numeric,
  pay_mode text,
  entered_by text,
  created_at timestamptz not null default now()
);
create index if not exists desk_visits_lead_idx on public.desk_visits(lead_id);
alter table public.desk_visits enable row level security;
revoke all on public.desk_visits from anon, authenticated;

create or replace function public.desk_add_visit(
  p_key text, p_lead_id uuid, p_clinic text, p_consult_amount numeric, p_medicine text,
  p_medicine_amount numeric, p_pay_mode text, p_entered_by text)
returns jsonb language plpgsql security definer set search_path to 'public' as '
declare v_id uuid;
begin
  if not desk_check_key(p_key) then raise exception ''not allowed''; end if;
  if p_lead_id is null then return jsonb_build_object(''ok'', false, ''error'', ''no such person''); end if;
  if coalesce(p_consult_amount,0) <= 0 and coalesce(p_medicine_amount,0) <= 0 then
    return jsonb_build_object(''ok'', false, ''error'', ''Enter an amount.''); end if;
  insert into desk_visits (lead_id, clinic, consult_amount, medicine, medicine_amount, pay_mode, entered_by)
  values (p_lead_id, nullif(trim(coalesce(p_clinic,'''')),''''), nullif(p_consult_amount,0), nullif(trim(coalesce(p_medicine,'''')),''''),
          nullif(p_medicine_amount,0), nullif(trim(coalesce(p_pay_mode,'''')),''''), nullif(trim(coalesce(p_entered_by,'''')),''''))
  returning id into v_id;
  update desk_leads set clinic = coalesce(clinic, nullif(trim(coalesce(p_clinic,'''')),'''')), updated_at = now() where id = p_lead_id;
  return jsonb_build_object(''ok'', true, ''id'', v_id);
end;';

create or replace function public.desk_visits_list(p_key text)
returns setof public.desk_visits language plpgsql security definer set search_path to 'public' as '
begin
  if not desk_check_key(p_key) then raise exception ''not allowed''; end if;
  return query select * from desk_visits order by visited_at desc;
end;';

-- ITEM 4. One read-only function for the Health screen: last month by funnel, month by
-- month by funnel, how many people ever bought a second pack, and clinic money once item 3 exists.
-- Reads only. Same security-definer shape as pulse_revenue.
create or replace function public.pulse_health()
returns json language sql security definer set search_path to 'public' as '
  with base as (
    select coalesce(amount_rupees,0)::numeric as amt,
           (coalesce(paid_at, created_at) at time zone ''Asia/Kolkata'') as ts,
           lower(trim(email)) as em, funnel,
           case when funnel = ''consult'' then ''consult''
                when funnel = ''consult-paid-ads'' then ''consult-paid-ads''
                when funnel = ''modak'' and pack = ''trial'' then ''modak-trial''
                when funnel = ''modak'' and pack = ''monthly'' then ''modak-monthly''
                when funnel = ''modak'' and pack = ''quarterly'' then ''modak-quarterly''
                else ''other'' end as bucket
    from public.revenue where status = ''captured''),
  nowist as (select (now() at time zone ''Asia/Kolkata'') as n),
  lastm as (select * from base, nowist where ts >= date_trunc(''month'', n) - interval ''1 month'' and ts < date_trunc(''month'', n))
  select json_build_object(
    ''last_month'', json_build_object(
       ''total'', (select coalesce(sum(amt),0) from lastm),
       ''count'', (select count(*) from lastm),
       ''buckets'', (select coalesce(json_object_agg(bucket, json_build_object(''count'', c, ''revenue'', r)),''{}''::json)
                     from (select bucket, count(*) c, sum(amt) r from lastm group by bucket) x)),
    ''by_month'', (select coalesce(json_agg(json_build_object(''month'', m, ''funnel'', f, ''count'', c, ''revenue'', r) order by m, f),''[]''::json)
                   from (select to_char(date_trunc(''month'', ts),''YYYY-MM'') m, coalesce(funnel,''other'') f, count(*) c, sum(amt) r
                         from base group by 1,2) y),
    ''repeat_buyers'', (select count(distinct b1.em) from base b1 where b1.funnel = ''modak''
                        and exists (select 1 from base b2 where b2.funnel = ''modak'' and b2.em = b1.em and b2.ts > b1.ts + interval ''5 days'')),
    ''consult_then_modak'', (select count(distinct b1.em) from base b1 where b1.funnel like ''consult%''
                        and exists (select 1 from base b2 where b2.funnel = ''modak'' and b2.em = b1.em)),
    ''clinic'', (select json_build_object(
                  ''visits'', count(*),
                  ''consult'', coalesce(sum(consult_amount),0),
                  ''medicine'', coalesce(sum(medicine_amount),0),
                  ''this_month'', coalesce(sum(case when visited_at >= date_trunc(''month'', now()) then coalesce(consult_amount,0)+coalesce(medicine_amount,0) else 0 end),0))
                from public.desk_visits)
  );';
