// /api/data — Pulse dashboard data endpoint
// Password-gated. Calls aggregation RPCs (no raw PII exposed unless authed).
// Env: SUPABASE_URL, SUPABASE_KEY (publishable), PULSE_PASSWORD

export default async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');

  // password check (sent as header from the gated page)
  // Two keys open this door. The client's key shows the four normal tabs.
  // Our own key does the same AND flags ops:true, which reveals the private
  // Opportunities tab. The client never learns the second key exists.
  const pass = req.headers['x-pulse-pass'] || (req.query && req.query.p) || '';
  const OPS = process.env.OPS_PASSWORD;
  const isOps = !!OPS && pass === OPS;
  if (pass !== process.env.PULSE_PASSWORD && !isOps) {
    return res.status(401).json({ error: 'unauthorized' });
  }

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
    return res.status(200).json({ ok: true, ops: isOps, stats, recent, revenue, revenue_recent, exec, content2, health });
  } catch (e) {
    return res.status(500).json({ error: 'fetch_failed', detail: String(e) });
  }
}
