// /api/data — Pulse dashboard data endpoint
// Password-gated. Calls aggregation RPCs (no raw PII exposed unless authed).
// Env: SUPABASE_URL, SUPABASE_KEY (publishable), PULSE_PASSWORD

export default async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');

  // password check (sent as header from the gated page)
  const pass = req.headers['x-pulse-pass'] || (req.query && req.query.p) || '';
  if (pass !== process.env.PULSE_PASSWORD) {
    return res.status(401).json({ error: 'unauthorized' });
  }

  const SUPABASE_URL = process.env.SUPABASE_URL;
  const KEY = process.env.SUPABASE_KEY;
  const headers = { 'apikey': KEY, 'Authorization': `Bearer ${KEY}`, 'Content-Type': 'application/json' };

  try {
    const [statsRes, recentRes] = await Promise.all([
      fetch(`${SUPABASE_URL}/rest/v1/rpc/pulse_stats`, { method: 'POST', headers, body: '{}' }),
      fetch(`${SUPABASE_URL}/rest/v1/rpc/pulse_recent`, { method: 'POST', headers, body: '{}' })
    ]);
    const stats = await statsRes.json();
    const recent = await recentRes.json();
    return res.status(200).json({ ok: true, stats, recent });
  } catch (e) {
    return res.status(500).json({ error: 'fetch_failed', detail: String(e) });
  }
}
