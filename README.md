# Woolexa Stealer — Malware Analysis

A static analysis writeup of **Woolexa Stealer**, a .NET-based infostealer / remote access trojan (RAT) distributed through trojanized Minecraft modpacks over Discord. The malware uses PNG steganography, in-memory .NET assembly loading, and a UAC bypass to steal browser credentials, Discord tokens, and gaming/social accounts while never writing its payload to disk.

> **Analysis only — no live malware in this repo.** All indicators below are defanged. Samples are not redistributed here; see [Samples](#samples).

---

## Summary

| | |
|---|---|
| **Family** | Woolexa Stealer |
| **Type** | Infostealer + RAT |
| **Platform** | Windows (.NET Framework 4.8) |
| **Delivery** | Malicious Minecraft modpack (`.mrpack`) via Discord |
| **C2** | `bigscreenmod[.]com` (REVERSE Panel) |
| **Actor handle** | `shelcodeloader` |
| **First observed** | March 2026 |
| **Status** | Original C2 restricted by Cloudflare 2026-06-06. **Actor rebuilt on `wlxproject[.]com` (registered 2026-07-26) — see [Update 2026-09-25](#update-2026-09-25--rebuilt-infrastructure-and-attribution)** |

The malware was delivered as `Minecraft Nightmare 1.0.0.mrpack` from a Discord account that had added the victim ~1 week earlier while posing as a friend. The account was 7 years old, consistent with a hijacked legitimate account used as a delivery vehicle. **The payload was never executed** — all findings come from static analysis.

## What it steals

- Browser cookies and saved passwords (Chrome, Firefox, Edge)
- Discord tokens (full account takeover)
- Steam session
- Spotify (`sp_dc` cookie), TikTok, Instagram
- Roblox account and Robux balance
- Victim IP, geolocation, and a per-victim hardware fingerprint (HWID)

## How it works

1. **Delivery** — `.mrpack` modpack containing `mcmod-1.0.0.jar` (Fabric mod `mcmod` v1.0.0, author `shelcodeloader`).
2. **Steganography** — encrypted payloads are hidden inside PNG texture files.
3. **Decryption** — payload is XOR-deobfuscated (key `qweqwe1`) then AES-256-CBC decrypted. The AES key is derived as `SHA-256("Shelcodeloader-embedded-key-v1")` with a fixed IV.
4. **In-memory execution** — a native C++ DLL (`ReflectiveClrHost.dll`) loads the .NET assembly (`BackendMinecraft`) entirely in RAM via reflective CLR hosting. Malicious code is never written to disk.
5. **Privilege escalation** — UAC bypass for elevation.
6. **Exfiltration** — collected data is sent to the C2 over HTTPS (`/api/collect`, `/api/progress`) and a WebSocket (`wss://bigscreenmod[.]com/agent-ws`).

## Update 2026-09-25 — rebuilt infrastructure and attribution

In September 2026 a second victim report reached a fellow researcher and was shared with us. The victim's household ran a Woolexa-style payload, lost Hotmail and Gmail access, and was then contacted with a ransom demand from a messaging account using the handle **`kuxey`**. The victim traced the profile picture to public social-media accounts whose bio links to a new domain.

That handle matches the build username `KUXEY` embedded in the malware's PDB path — a string recovered from the binary in June and never previously published as a handle — so it corroborates the original attribution independently.

| Type | Indicator | Notes |
|---|---|---|
| Domain | `wlxproject[.]com` | Registered 2026-07-26 at Dynadot (privacy-proxied); Cloudflare-fronted |
| Panel | `hxxps://wlxproject[.]com/` | Turkish login ("GÜVENLİ GİRİŞ / Workspace'e eriş"), 32-char access key with `wlx_` prefix — the same build-key login model as the original REVERSE Panel |
| Handle | `kuxey` | Ransom contact handle (victim report) |
| Handle | `3xkuxey` / `3xkuzey` | Public social accounts; display name "Kuzey", bio "Malware dev#", bio link `wlxproject[.]com` |

"WLX" is the Woolexa brand; the panel's page language is Turkish, consistent with the original C2 and code comments. All observations of the new domain were made passively (registration data, certificate transparency, public urlscan.io scans). The domain has been reported to Cloudflare and the registrar.

## Detailed analysis

- [Static analysis](analysis/static.md) — obfuscation, crypto constants, embedded artifacts
- [Behavioral analysis](analysis/behavioral.md) — execution chain, persistence, theft targets
- [Network / C2](analysis/network.md) — infrastructure, endpoints, panel history
- [Indicators of Compromise](IOCs.md) — full IOC table ([raw lists](indicators/))
- [Detection rules](detection/) — YARA
- [Timeline](timeline.md) — investigation and disclosure history

## Indicators (quick reference)

| Type | Indicator |
|---|---|
| C2 domain | `bigscreenmod[.]com` |
| C2 panel | `hxxps://bigscreenmod[.]com/auth` |
| C2 WebSocket | `wss://bigscreenmod[.]com/agent-ws` |
| Origin IP | `130.12.242[.]204` |
| XOR key | `qweqwe1` |
| AES key seed | `Shelcodeloader-embedded-key-v1` |
| PDB path | `C:\Users\KUXEY\Desktop\shelcodeloader\NativeHost\x64\Release\reflective_clr_host.pdb` |
| Assembly name | `BackendMinecraft` |
| Loader DLL | `ReflectiveClrHost.dll` |

Full list with defanged URLs and hashes: **[IOCs.md](IOCs.md)**.

## Samples

Live samples and decompiled source are **not** hosted in this repo to avoid redistributing working malware. The sample has been submitted to public malware-intelligence platforms — see [IOCs.md](IOCs.md) for hashes and references. Vetted researchers can request access through the contact below.

## Disclosure

This actor's infrastructure was reported to Cloudflare, GoDaddy, the hosting provider (AS210558), Discord, Mojang/Microsoft, and the FBI's IC3. See [timeline.md](timeline.md) for the full disclosure record. Cloudflare restricted access to the C2 the same day the report was filed (2026-06-06).

## References

- **QuantumCore — "Woolexa Stealer - Full Malware Analysis Report" (2026-06-17)**: an independent, deeper reverse of the same sample covering the HVNC remote-access channel, microphone/screen capture, WMI event-subscription persistence, exfiltration crypto, build keys, and the embedded Steam Web API key. Recommended companion to this repo. `hxxps://quantumcore.github[.]io/2026/06/17/woolexa-stealer-analysis.html`
- **TheRealLo — "This Minecraft dupe mod is a RAT" (2026-02-23)**: analysis of a near-identical Minecraft Fabric mod → in-memory .NET RAT with a native UAC-bypass loader; likely the same family or toolkit, different C2 design. `hxxps://thereallo[.]dev/blog/this-minecraft-dupe-mod-is-a-rat`

## License / use

Indicators and detection rules are published for defensive use. TLP:CLEAR — share freely. Please credit if you reuse the analysis.

---

*Author: Cipher Ghost · Independent security research · Published 2026-06-10 · Updated 2026-09-25*
