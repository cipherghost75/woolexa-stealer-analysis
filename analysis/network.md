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

## Successor infrastructure — `wlxproject[.]com` (added 2026-09-25)

| Property | Value |
|---|---|
| Domain | `wlxproject[.]com` |
| Registered | 2026-07-26 13:39 UTC — Dynadot, privacy-proxied (Super Privacy Service LTD c/o Dynadot) |
| Nameservers | `jerome.ns.cloudflare[.]com`, `simone.ns.cloudflare[.]com` |
| Cloudflare fronts | `104.21.85[.]110`, `172.67.204[.]163` |
| TLS | Google Trust Services (WE1), first issued 2026-07-26 |
| Page language | Turkish |
| Login | "GÜVENLİ GİRİŞ — Workspace'e eriş — Devam etmek için WLX erişim key'ini gir"; single field, `wlx_` prefix, 32-char key; "Key bilgisi tarayıcıda saklanmaz" |

The panel appeared seven weeks after the original C2 was restricted. It keeps the operator model of the REVERSE Panel — one secret key is the whole credential, the same design QuantumCore flagged as an authentication weakness on the original — but moves to a new registrar and a new brand ("WLX"). No agent endpoints have been enumerated on the new host; all observation was passive (RDAP, DNS, public urlscan.io scan `019fa79f-926c-71d5-b672-e8fcaba84bea`). The domain was linked to the operator by a victim who followed the ransom contact's profile picture to public social accounts whose bio carries this domain.

## Third-party scans

- 2026-07-28 (wlxproject access-key panel): `hxxps://urlscan[.]io/result/019fa79f-926c-71d5-b672-e8fcaba84bea/`

- 2026-05-29 (live panel): `hxxps://urlscan[.]io/result/019e7349-8f64-76cc-addf-38e5acc5ddc4/`
- 2026-04-27 (Turkish login): `hxxps://urlscan[.]io/result/019dcebe-cf65-77bf-822b-dbdce6e828e9/`
- 2026-03-17 (phishing flagged): `hxxps://urlscan[.]io/result/019cfafa-0fb1-70be-8b17-e48f82c80a62/`

## Hunting notes

- Expect a **new domain** if the actor resurfaces — they rebuilt once already.
- Pivot points: AS210558 origin hosting, GoDaddy registration pattern, REVERSE Panel fingerprints, the `/agent-ws` + `/api/collect` endpoint pair.
- New pivots (2026-09): Dynadot + Cloudflare pairing, Turkish key-login page text, `wlx_` key prefix, "WLX" branding, and any domain linked from the `3xkuxey` / `3xkuzey` profiles.
