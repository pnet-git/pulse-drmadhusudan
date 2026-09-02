// /api/desk — Follow-up desk endpoint
// Same password gate as /api/data. All DB access goes through security-definer
// RPCs that require DESK_KEY, so the publishable key alone can read nothing.
// Env: SUPABASE_URL, SUPABASE_KEY (publishable), PULSE_PASSWORD, DESK_KEY,
//      KIT_API_KEY (optional — enables pulling fresh page leads from Kit)

const KIT_TAGS = [
  { id: 17730698, source: 'Consultation page' },
  { id: 19525359, source: 'Modak page' },
  { id: 20107592, source: 'Routine' }
];

export default async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');

  // Two keys open this door, same as /api/data. The client's key and our own
  // ops key. Before 21 Aug only the client's key worked here, so logging in
  // with the ops key showed an empty Lead Tracking tab and every add, update
  // and sync failed silently with a 401.
  const pass = req.headers['x-pulse-pass'] || '';
  const OPS = process.env.OPS_PASSWORD;
  if (pass !== process.env.PULSE_PASSWORD && !(OPS && pass === OPS)) {
    return res.status(401).json({ error: 'unauthorized' });
  }

  const SUPABASE_URL = process.env.SUPABASE_URL;
  const KEY = process.env.SUPABASE_KEY;
  const DESK_KEY = process.env.DESK_KEY;
  const headers = { 'apikey': KEY, 'Authorization': `Bearer ${KEY}`, 'Content-Type': 'application/json' };

  if (!DESK_KEY) return res.status(500).json({ error: 'DESK_KEY env var missing' });

  const rpc = (fn, body) =>
    fetch(`${SUPABASE_URL}/rest/v1/rpc/${fn}`, { method: 'POST', headers, body: JSON.stringify(body) });

  try {
    if (req.method === 'GET') {
      const [lr, tr, sr, vr] = await Promise.all([
        rpc('desk_list', { p_key: DESK_KEY }),
        rpc('desk_team_list', { p_key: DESK_KEY }),
        rpc('desk_status_list', { p_key: DESK_KEY }),
        rpc('desk_visits_list', { p_key: DESK_KEY })   // clinic sales; 404 until the table exists
      ]);
      const rows = await lr.json();
      const team = await tr.json();
      const statuses = await sr.json();
      const visits = vr.ok ? await vr.json() : [];
      if (!lr.ok) return res.status(500).json({ error: 'list_failed', detail: rows });
      return res.status(200).json({ ok: true, leads: rows,
        team: Array.isArray(team) ? team : [],
        statuses: Array.isArray(statuses) ? statuses : [],
        visits: Array.isArray(visits) ? visits : [],
        visits_on: vr.ok });
    }

    const body = typeof req.body === 'string' ? JSON.parse(req.body || '{}') : (req.body || {});

    if (body.action === 'add') {
      const args = {
        p_key: DESK_KEY,
        p_name: body.name || '',
        p_phone: body.phone || '',
        p_email: body.email || null,
        p_source: body.source || '',
        p_note: body.note || null,
        p_assigned: body.assigned_to || null,
        p_phone_alt: body.phone_alt || null,
        p_age: body.age || null,
        p_location: body.location || null,
        p_marital: body.marital_status || null,
        p_lead_source: body.lead_source || null,
        p_came_for: body.came_for || null
      };
      // The clinic column arrives with the v2 database delta. Until then the
      // function does not know p_clinic and answers 404, so we retry without it.
      let r = await rpc('desk_add_person', Object.assign({ p_clinic: body.clinic || null }, args));
      if (r.status === 404) r = await rpc('desk_add_person', args);
      const out = await r.json();
      if (!r.ok) return res.status(500).json({ error: 'add_failed', detail: out });
      return res.status(200).json(out);
    }

    // A sale made at the desk: consultation fee, medicine, or both. Cash, UPI or card.
    // Lives in desk_visits, which arrives with the v2 delta. 404 until then.
    if (body.action === 'visit') {
      const r = await rpc('desk_add_visit', {
        p_key: DESK_KEY,
        p_lead_id: body.lead_id,
        p_clinic: body.clinic || null,
        p_consult_amount: body.consult_amount || null,
        p_medicine: body.medicine || null,
        p_medicine_amount: body.medicine_amount || null,
        p_pay_mode: body.pay_mode || null,
        p_entered_by: body.entered_by || null
      });
      if (r.status === 404) return res.status(200).json({ ok: false, error: 'Clinic sales are not switched on yet.' });
      const out = await r.json();
      if (!r.ok) return res.status(500).json({ error: 'visit_failed', detail: out });
      return res.status(200).json(out);
    }

    if (body.action === 'update') {
      const r = await rpc('desk_update', {
        p_key: DESK_KEY,
        p_id: body.id,
        p_status: body.status || null,
        p_next_followup: body.next_followup || null,
        p_note: body.note || null,
        p_assigned: body.assigned_to || null,
        p_delivered: body.delivered_on || null,
        p_dispatched: body.dispatched_on || null,
        p_appt_at: body.appointment_at === undefined ? null : body.appointment_at,
        p_appt_mode: body.appointment_mode || null
      });
      const out = await r.json();
      if (!r.ok) return res.status(500).json({ error: 'update_failed', detail: out });
      return res.status(200).json(out);
    }

    if (body.action === 'sync') {
      let kit_added = 0, kit_error = null;

      // Fresh page leads from Kit, when a key is configured.
      // One batched RPC per tag — never one call per person.
      if (process.env.KIT_API_KEY) {
        try {
          for (const tag of KIT_TAGS) {
            const rows = [];
            let after = null;
            do {
              const url = `https://api.kit.com/v4/tags/${tag.id}/subscribers?per_page=500` +
                          (after ? `&after=${encodeURIComponent(after)}` : '');
              const kr = await fetch(url, {
                headers: { 'X-Kit-Api-Key': process.env.KIT_API_KEY, 'Accept': 'application/json' }
              });
              if (!kr.ok) throw new Error(`Kit tag ${tag.id}: ${kr.status}`);
              const kd = await kr.json();
              for (const s of (kd.subscribers || [])) {
                rows.push({
                  email: s.email_address,
                  name: s.first_name || '',
                  phone: (s.fields && s.fields.phone_number) || '',
                  first: s.created_at || null
                });
              }
              after = kd.pagination && kd.pagination.has_next_page ? kd.pagination.end_cursor : null;
            } while (after);
            if (rows.length) {
              const up = await rpc('desk_upsert_many', { p_key: DESK_KEY, p_source: tag.source, p_rows: rows });
              const uo = await up.json();
              if (up.ok && uo && uo.touched != null) kit_added += Number(uo.touched);
            }
          }
        } catch (e) {
          kit_error = String(e);
        }
      }

      // Payments + assessment sync and the Converted flip, always.
      const r = await rpc('desk_sync', { p_key: DESK_KEY });
      const out = await r.json();
      if (!r.ok) return res.status(500).json({ error: 'sync_failed', detail: out });
      return res.status(200).json({ ...out, kit_touched: kit_added, kit_error });
    }

    return res.status(400).json({ error: 'unknown_action' });
  } catch (e) {
    return res.status(500).json({ error: 'desk_failed', detail: String(e) });
  }
}
