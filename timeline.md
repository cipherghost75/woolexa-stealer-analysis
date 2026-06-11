# Timeline — Woolexa Stealer

## Infrastructure activity (from urlscan.io and direct observation)

| Date | Event |
|---|---|
| ~Mid-March 2026 | `bigscreenmod[.]com` registered via GoDaddy |
| 2026-03-17 | C2 first detected; flagged phishing/threat |
| 2026-03-21 | Server went down (likely a prior takedown) |
| 2026-04-27 | Rebuilt with Turkish login page ("Bireysel Giriş") |
| 2026-05-29 | Fully operational REVERSE Panel observed |
| 2026-06-06 | Cloudflare restricted access (403 Forbidden confirmed) |

## Investigation & disclosure

| Date / time | Action | Reference |
|---|---|---|
| ~1 week prior to 2026-06-06 | Attacker Discord account (7-yr-old, likely hijacked) added victim posing as a friend | Discord ID `543708648233369610` |
| 2026-06-06 | Malicious modpack received; **not executed**; static analysis performed | — |
| 2026-06-06 | Cloudflare abuse report filed; access restricted same day | Report ID `a3b4d2e080b4ca8f` |
| 2026-06-06 | Cloudflare forwarded report to hosting provider | `abuse@as210558[.]net` |
| 2026-06-06 | GoDaddy domain-suspension request filed (pending) | Case `DCU101367879` |
| 2026-06-06 01:59 EST | IC3 complaint #1 (initial) | Submission `368d390bbdeb426284e8413bb5321f79` |
| 2026-06-06 17:05 EST | IC3 complaint #2 (full technical evidence) | Submission `e86902083eed482fb763a61e37bae63f` |
| 2026-06-06 | Discord abuse report filed for sender account | Account `543708648233369610` |
| 2026-06-06 | Mojang/Microsoft report filed | `dailussxd` / UUID `ac4b71bf-ca5a-4801-9654-829d67a9fc3b` |

## Corroborating signals

- Gmail automatically blocked the original modpack as a security threat.
- Gmail flagged `payload_decrypted.bin` as "Virus detected".
- Cloudflare confirmed 403 Forbidden after restricting access on 2026-06-06.

## Assessment

- The actor was knocked down once (March 2026) and rebuilt — expect a new domain if they resurface.
- Future builds will likely reuse the XOR key (`qweqwe1`) and AES key derivation (`SHA-256("Shelcodeloader-embedded-key-v1")`), making the YARA constants durable across versions.
- The REVERSE Panel supports multiple operators via build keys — other victims likely exist.
- Monitoring targets: handle `shelcodeloader`, Minecraft account `dailussxd`, family name "Woolexa Stealer".
