# Network / C2 Analysis — Woolexa Stealer

## Command & control

| Property | Value |
|---|---|
| C2 domain | `bigscreenmod[.]com` |
| Panel | `hxxps://bigscreenmod[.]com/auth` (REVERSE Panel login) |
| WebSocket | `wss://bigscreenmod[.]com/agent-ws` |
| Exfil endpoints | `/api/collect`, `/api/progress` |
| Agent channel | `/agent-ws` |

## Hosting & infrastructure

| Property | Value |
|---|---|
| Origin server IP | `130.12.242[.]204` (observed April 2026) |
| Origin host / ASN | `AS210558` — abuse: `abuse@as210558[.]net` |
| CDN | Cloudflare — `104.21.64[.]58`, `172.67.176[.]167` |
| Registrar | GoDaddy |
| Registered | ~mid-March 2026 |

The C2 sits behind Cloudflare, which fronts the AS210558 origin. The origin IP was exposed in April 2026 observation.

## Panel history

| Date | State |
|---|---|
| 2026-03-17 | First detected, flagged phishing/threat |
| 2026-03-21 | Down (likely prior takedown) |
| 2026-04-27 | Rebuilt — Turkish login page ("Bireysel Giriş") |
| 2026-05-29 | Fully operational REVERSE Panel |
| 2026-06-06 | Cloudflare restricted access — 403 Forbidden |

## Third-party scans

- 2026-05-29 (live panel): `hxxps://urlscan[.]io/result/019e7349-8f64-76cc-addf-38e5acc5ddc4/`
- 2026-04-27 (Turkish login): `hxxps://urlscan[.]io/result/019dcebe-cf65-77bf-822b-dbdce6e828e9/`
- 2026-03-17 (phishing flagged): `hxxps://urlscan[.]io/result/019cfafa-0fb1-70be-8b17-e48f82c80a62/`

## Hunting notes

- Expect a **new domain** if the actor resurfaces — they rebuilt once already.
- Pivot points: AS210558 origin hosting, GoDaddy registration pattern, REVERSE Panel fingerprints, the `/agent-ws` + `/api/collect` endpoint pair.
