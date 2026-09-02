-- PULSE v2 DATABASE DELTA. Dr Madhu's live client database praswrwxhdvtnlcevmtz.
-- APPLIED 2 Sep 2026 on the King's yes, all items, in this order, with execute_sql. Kept as the record.
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
  quantity integer,
  days integer,
  consult_mode text,
  recurring boolean,
  created_at timestamptz not null default now()
);
create index if not exists desk_visits_lead_idx on public.desk_visits(lead_id);
alter table public.desk_visits enable row level security;
revoke all on public.desk_visits from anon, authenticated;

create or replace function public.desk_add_visit(
  p_key text, p_lead_id uuid, p_clinic text, p_consult_amount numeric, p_medicine text,
  p_medicine_amount numeric, p_pay_mode text, p_entered_by text,
  p_quantity integer default null, p_days integer default null, p_consult_mode text default null, p_recurring boolean default null)
returns jsonb language plpgsql security definer set search_path to 'public' as '
declare v_id uuid;
begin
  if not desk_check_key(p_key) then raise exception ''not allowed''; end if;
  if p_lead_id is null then return jsonb_build_object(''ok'', false, ''error'', ''no such person''); end if;
  if coalesce(p_consult_amount,0) <= 0 and coalesce(p_medicine_amount,0) <= 0 then
    return jsonb_build_object(''ok'', false, ''error'', ''Enter an amount.''); end if;
  insert into desk_visits (lead_id, clinic, consult_amount, medicine, medicine_amount, pay_mode, entered_by, quantity, days, consult_mode, recurring)
  values (p_lead_id, nullif(trim(coalesce(p_clinic,'''')),''''), nullif(p_consult_amount,0), nullif(trim(coalesce(p_medicine,'''')),''''),
          nullif(p_medicine_amount,0), nullif(trim(coalesce(p_pay_mode,'''')),''''), nullif(trim(coalesce(p_entered_by,'''')),''''),
          p_quantity, p_days, nullif(trim(coalesce(p_consult_mode,'''')),''''), p_recurring)
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

-- ITEM 3b. The medicine list reception picks from, and can add to. Seeded from the store's
-- own product list. Same lock as desk_visits.
create table if not exists public.desk_medicines (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  price numeric,
  days integer,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
alter table public.desk_medicines enable row level security;
revoke all on public.desk_medicines from anon, authenticated;
insert into public.desk_medicines (name, price, days) values
  ('Kamdev Modak, 7 day trial', 1490, 7), ('Kamdev Modak, 1 month', 5550, 30), ('Kamdev Modak, 3 months', 15000, 90),
  ('Gandiva Dhairya Capsules', 2650, 30), ('Gandiva Sanjivani Capsules', 3799, 30), ('Gandiva Shukrabandhan Vati', 1850, 30),
  ('Gandiva Stallion Pro Capsule', null, 30), ('Stallion Ultra Max Capsules', null, 30),
  ('Shakti Plus 180gm', 7500, 30), ('L-69 Capsule', 2650, 30), ('T-69 Capsule', 2850, 30),
  ('Joyque Max 10 Tablets', 880, 10), ('Joyque 60 Capsules', 2880, 30), ('NotOut Testosterone Booster', 2500, 30),
  ('Vajra Shilajit Gold', 1950, 30), ('ReBOOST Plus Powder 180gm', 2550, 30), ('ReBOOST Capsule', 1850, 30),
  ('Ashwakanchuki Ras', 399, 30), ('Thyromrit 60 Capsule', 1380, 30), ('Yakritamrit', 950, 30),
  ('Lipoma Herbal Mix 60 Dose', 5500, 30), ('Dhanvantari Garbh Dharini 50 Vati', 2120, 30),
  ('Twachamrit Skin Oil and Drop Combo', 2599, 30), ('Health Gainer Powder 200gm', 2399, 30),
  ('Majja Shodhak 60 Tablet', 350, 30), ('Sukuntalam 60 Tablet', 375, 30)
on conflict (name) do nothing;

create or replace function public.desk_medicine_list(p_key text)
returns setof public.desk_medicines language plpgsql security definer set search_path to 'public' as '
begin
  if not desk_check_key(p_key) then raise exception ''not allowed''; end if;
  return query select * from desk_medicines where active order by name;
end;';

create or replace function public.desk_medicine_add(p_key text, p_name text, p_price numeric, p_days integer)
returns jsonb language plpgsql security definer set search_path to 'public' as '
declare v_id uuid;
begin
  if not desk_check_key(p_key) then raise exception ''not allowed''; end if;
  if coalesce(trim(p_name),'''') = '''' then return jsonb_build_object(''ok'', false, ''error'', ''Enter the medicine name.''); end if;
  insert into desk_medicines (name, price, days) values (trim(p_name), nullif(p_price,0), coalesce(p_days,30))
  on conflict (name) do update set price = coalesce(excluded.price, desk_medicines.price), active = true
  returning id into v_id;
  return jsonb_build_object(''ok'', true, ''id'', v_id);
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
