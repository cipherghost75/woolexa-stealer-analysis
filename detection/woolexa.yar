rule Woolexa_Stealer
{
    meta:
        description = "Detects Woolexa Stealer .NET infostealer/RAT (Minecraft modpack delivery)"
        author      = "Cipher Ghost"
        date        = "2026-06-10"
        reference   = "https://github.com/cipherghost75/woolexa-stealer-analysis"
        malware     = "Woolexa Stealer"
        actor       = "shelcodeloader"
        hash        = "f3bbbb6f0e2018b7cec514b44f0823eba30fa70383ca5a0c5d7a9f0c6563ff77"
        tlp         = "white"

    strings:
        // Crypto / identity constants (high confidence)
        $aes_seed = "Shelcodeloader-embedded-key-v1" ascii wide
        $iv       = { AB AE A1 61 0C 9B 23 AA 03 5B F1 42 34 63 9C 2A }
        $xor      = "qweqwe1" ascii wide

        // Build / assembly artifacts
        $pdb      = "reflective_clr_host.pdb" ascii
        $pdb_path = "shelcodeloader\\NativeHost" ascii
        $asm      = "BackendMinecraft" ascii wide
        $dll      = "ReflectiveClrHost.dll" ascii wide
        $author   = "shelcodeloader" ascii wide

        // C2 / network
        $c2       = "bigscreenmod.com" ascii wide
        $ep1      = "/api/collect" ascii wide
        $ep2      = "/agent-ws" ascii wide

    condition:
        // The AES seed or fixed IV alone is near-unique; otherwise require
        // a combination of weaker artifacts to fire.
        $aes_seed or $iv or 3 of them
}
