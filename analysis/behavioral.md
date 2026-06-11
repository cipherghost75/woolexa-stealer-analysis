# Behavioral Analysis — Woolexa Stealer

> Derived from static analysis of the sample; behavior described is what the
> code is built to do. The payload was **not** detonated.

## Execution chain

1. Victim installs/launches the `Minecraft Nightmare 1.0.0.mrpack` modpack containing `mcmod-1.0.0.jar`.
2. The mod extracts an encrypted payload hidden via PNG steganography in texture files.
3. Payload is XOR-deobfuscated (`qweqwe1`) and AES-256-CBC decrypted (`SHA-256("Shelcodeloader-embedded-key-v1")`, fixed IV).
4. Native `ReflectiveClrHost.dll` reflectively loads the .NET `BackendMinecraft` assembly directly into memory — nothing malicious touches disk.
5. UAC bypass elevates privileges.
6. Collection runs; data is exfiltrated to the C2 (see [network.md](network.md)).

## Theft targets

| Category | Detail |
|---|---|
| Browser credentials | Cookies and saved passwords — Chrome, Firefox, Edge |
| Discord | Account tokens → full account takeover |
| Steam | Session |
| Spotify | Account via `sp_dc` cookie |
| TikTok | Account |
| Instagram | Account |
| Roblox | Account and Robux balance |
| Host recon | Victim IP, geolocation, per-victim hardware fingerprint (HWID) |

## Notable traits

- **Fileless execution** — in-memory .NET loading defeats disk-based AV scanning of the payload.
- **HWID fingerprinting** — unique per victim, enabling per-victim tracking in the C2 panel.
- **Multi-operator C2** — the REVERSE Panel supports multiple operators via build keys, implying a shared/sold builder and multiple victim sets.
