# Indicators of Compromise — Woolexa Stealer

All indicators are **defanged**. Re-fang before use in tooling (`[.]` → `.`, `hxxp` → `http`, `wss` unchanged but host defanged).

Machine-readable copies are in [`indicators/`](indicators/).

## Network

| Type | Indicator | Notes |
|---|---|---|
| Domain | `bigscreenmod[.]com` | C2 / REVERSE Panel |
| URL | `hxxps://bigscreenmod[.]com/auth` | Panel login |
| URL | `wss://bigscreenmod[.]com/agent-ws` | Agent WebSocket |
| URI path | `/api/collect` | Exfiltration endpoint |
| URI path | `/api/progress` | Exfiltration endpoint |
| URI path | `/agent-ws` | C2 WebSocket endpoint |
| IPv4 | `130.12.242[.]204` | Origin server (observed April 2026) |
| IPv4 | `104.21.64[.]58` | Cloudflare front |
| IPv4 | `172.67.176[.]167` | Cloudflare front |
| ASN | `AS210558` | Origin hosting (`abuse@as210558[.]net`) |
| Registrar | GoDaddy | Domain registered ~mid-March 2026 |

## Host / file

| Type | Indicator | Notes |
|---|---|---|
| Filename | `Minecraft Nightmare 1.0.0.mrpack` | Delivery container |
| Filename | `mcmod-1.0.0.jar` | Malicious mod (~9.7 MB) |
| Filename | `ReflectiveClrHost.dll` | Native CLR loader |
| Filename | `reflective_clr_host.pdb` | Debug artifact |
| Filename | `payload_decrypted.bin` | Decrypted .NET payload |
| Assembly | `BackendMinecraft` | .NET assembly name |
| Fabric mod | `mcmod` v1.0.0, author `shelcodeloader` | |
| PDB path | `C:\Users\KUXEY\Desktop\shelcodeloader\NativeHost\x64\Release\reflective_clr_host.pdb` | Reveals build username `KUXEY` |

## Cryptographic / code constants

| Type | Indicator | Notes |
|---|---|---|
| XOR key | `qweqwe1` | Payload deobfuscation |
| AES key seed | `Shelcodeloader-embedded-key-v1` | `key = SHA-256(seed)` |
| AES IV | `AB AE A1 61 0C 9B 23 AA 03 5B F1 42 34 63 9C 2A` | Fixed, AES-256-CBC |
| Technique | PNG steganography | Encrypted payload hidden in textures |

## File hashes

**`mcmod-1.0.0.jar`** — the malicious Fabric mod (9,719,067 bytes):

| Algorithm | Hash |
|---|---|
| SHA256 | `f3bbbb6f0e2018b7cec514b44f0823eba30fa70383ca5a0c5d7a9f0c6563ff77` |
| SHA1 | `0bf9a37ef312f16166acd6067af3060f0c49ef5d` |
| MD5 | `68afef46394acdd957e60640256089b3` |

> The delivery container `Minecraft Nightmare 1.0.0.mrpack` and the decrypted
> in-memory payload `payload_decrypted.bin` were not retained for hashing.

## Actor

| Type | Indicator |
|---|---|
| Handle | `shelcodeloader` |
| Build username (PDB) | `KUXEY` |
| Minecraft username | `dailussxd` |
| Minecraft UUID | `ac4b71bf-ca5a-4801-9654-829d67a9fc3b` |
| Discord sender ID | `543708648233369610` |
| Language | Turkish (code + C2 panel) |

## Third-party references

| Date | Source |
|---|---|
| 2026-05-29 | urlscan: `hxxps://urlscan[.]io/result/019e7349-8f64-76cc-addf-38e5acc5ddc4/` |
| 2026-04-27 | urlscan: `hxxps://urlscan[.]io/result/019dcebe-cf65-77bf-822b-dbdce6e828e9/` |
| 2026-03-17 | urlscan: `hxxps://urlscan[.]io/result/019cfafa-0fb1-70be-8b17-e48f82c80a62/` |
