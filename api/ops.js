// /api/ops — the private Opportunities tab. OURS, not the client's.
// Gated on OPS_PASSWORD, which is a different key from PULSE_PASSWORD.
// The client's key opens the four normal tabs and gets 401 here.
// Env: SUPABASE_URL, SUPABASE_KEY (publishable), OPS_PASSWORD, DESK_KEY

export default async function handler(req, res) {
  res.setHeader('Content-Type', 'application/json');

  const pass = req.headers['x-ops-pass'] || '';
  if (!process.env.OPS_PASSWORD || pass !== process.env.OPS_PASSWORD) {
    return res.status(401).json({ error: 'unauthorized' });
  }

  const SUPABASE_URL = process.env.SUPABASE_URL;
  const KEY = process.env.SUPABASE_KEY;
  const DESK_KEY = process.env.DESK_KEY;
  if (!DESK_KEY) return res.status(500).json({ error: 'DESK_KEY env var missing' });

  const headers = { 'apikey': KEY, 'Authorization': `Bearer ${KEY}`, 'Content-Type': 'application/json' };

  try {
    const r = await fetch(`${SUPABASE_URL}/rest/v1/rpc/ops_intel`, {
      method: 'POST', headers, body: JSON.stringify({ p_key: DESK_KEY })
    });
    const intel = await r.json();
    if (!r.ok) return res.status(500).json({ error: 'intel_failed', detail: intel });
    return res.status(200).json({ ok: true, intel });
  } catch (e) {
    return res.status(500).json({ error: 'fetch_failed', detail: String(e) });
  }
}
