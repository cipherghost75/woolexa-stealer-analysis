# Static Analysis — Woolexa Stealer

The sample was analyzed **statically only**; the payload was never executed.

## Container & mod

- **Delivery container:** `Minecraft Nightmare 1.0.0.mrpack` (Modrinth modpack format).
- **Malicious component:** `mcmod-1.0.0.jar` (~9.7 MB).
- **Fabric metadata:** mod id `mcmod`, version `1.0.0`, author `shelcodeloader`.
- **Managed framework:** .NET Framework 4.8; assembly name `BackendMinecraft`.

## Obfuscation & payload protection

| Layer | Detail |
|---|---|
| Steganography | Encrypted payloads hidden inside PNG texture files |
| Obfuscation | XOR with key `qweqwe1` |
| Encryption | AES-256-CBC |
| Key derivation | `key = SHA-256("Shelcodeloader-embedded-key-v1")` |
| IV | Fixed: `AB AE A1 61 0C 9B 23 AA 03 5B F1 42 34 63 9C 2A` |
| Loader | Native C++ `ReflectiveClrHost.dll` loads the .NET assembly entirely in RAM (reflective CLR hosting) |
| Anti-forensics | Malicious code never written to disk |
| Privilege escalation | UAC bypass |

## Build artifacts (attribution)

- **PDB path:** `C:\Users\KUXEY\Desktop\shelcodeloader\NativeHost\x64\Release\reflective_clr_host.pdb`
  - Leaks the build-machine username `KUXEY` and the project name `shelcodeloader`.
- **Native loader project:** `NativeHost` → `reflective_clr_host`.
- Turkish-language strings in code and C2 panel indicate a Turkish-speaking operator.

## Durable detection constants

These are baked into the malware's design and are expected to survive across versions, making them strong YARA anchors:

- AES key seed string `Shelcodeloader-embedded-key-v1`
- Fixed AES IV (16 bytes above)
- XOR key `qweqwe1`
- Assembly name `BackendMinecraft`, loader `ReflectiveClrHost.dll`

See [`detection/woolexa.yar`](../detection/woolexa.yar).
