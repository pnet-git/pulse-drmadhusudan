// /api/data — Pulse dashboard data endpoint
// Password-gated. Calls aggregation RPCs (no raw PII exposed unless authed).
// Env: SUPABASE_URL, SUPABASE_KEY (publishable), PULSE_PASSWORD

export default async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');

  // THREE KEYS, THREE ROLES (2 Sep 2026).
  //   team   = PULSE_PASSWORD.  The clinic staff. They get the patient list and
  //            reception only, so this endpoint hands them no dashboard numbers.
  //   doctor = DOCTOR_PASSWORD. Dr Madhu himself. Everything the team sees plus
  //            Health and Content.
  //   ops    = OPS_PASSWORD.    Us. Everything, plus the private Opportunities box.
  // ONE KEY PER CLINIC (pass 3, 14 Sep 2026). Ritesh's ask: not a login per person, a
  // login per clinic. TEAM_KEY_KALKAJI and TEAM_KEY_GURGAON each open the team view
  // and tell the app which clinic it is, so nobody picks it on the phone. The old
  // PULSE_PASSWORD still works and leaves the clinic to be chosen on the device.
  const pass = req.headers['x-pulse-pass'] || (req.query && req.query.p) || '';
  const OPS = process.env.OPS_PASSWORD, DOC = process.env.DOCTOR_PASSWORD;
  const KAL = process.env.TEAM_KEY_KALKAJI, GGN = process.env.TEAM_KEY_GURGAON;
  const clinic = (KAL && pass === KAL) ? 'Delhi clinic' : (GGN && pass === GGN) ? 'Gurgaon clinic' : '';
  const role = (OPS && pass === OPS) ? 'ops' : (DOC && pass === DOC) ? 'doctor'
             : (clinic || pass === process.env.PULSE_PASSWORD) ? 'team' : null;
  if (!role) return res.status(401).json({ error: 'unauthorized' });
  const isOps = role === 'ops';
  if (role === 'team') return res.status(200).json({ ok: true, role, ops: false, clinic });

  const SUPABASE_URL = process.env.SUPABASE_URL;
  const KEY = process.env.SUPABASE_KEY;
  const headers = { 'apikey': KEY, 'Authorization': `Bearer ${KEY}`, 'Content-Type': 'application/json' };
  const rpc = (fn) => fetch(`${SUPABASE_URL}/rest/v1/rpc/${fn}`, { method: 'POST', headers, body: '{}' });

  try {
    const [statsRes, recentRes, revRes, revRecentRes, execRes, content2Res, healthRes] = await Promise.all([
      rpc('pulse_stats'),
      rpc('pulse_recent'),
      rpc('pulse_revenue'),
      rpc('pulse_revenue_recent'),
      rpc('pulse_exec'),
      rpc('pulse_content_v2'),
      rpc('pulse_health')      // v2: last month by funnel, repeat buyers. 404 until the delta lands.
    ]);
    const stats = await statsRes.json();
    const recent = await recentRes.json();
    const revenue = await revRes.json();
    const revenue_recent = await revRecentRes.json();
    const exec = await execRes.json();
    const content2 = await content2Res.json();
    const health = healthRes.ok ? await healthRes.json() : null;
    return res.status(200).json({ ok: true, role, ops: isOps, stats, recent, revenue, revenue_recent, exec, content2, health });
  } catch (e) {
    return res.status(500).json({ error: 'fetch_failed', detail: String(e) });
  }
}
