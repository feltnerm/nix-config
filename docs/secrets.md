# Secrets Management with agenix (ragenix)

This repo uses age/agenix (ragenix) for encrypted secrets.

## Key Concepts
- Per-host secrets: stored under `secrets/hosts/<hostname>/...`
- Per-user secrets: stored under `secrets/users/<username>/...`
- Access control: `secrets/secrets.nix` lists age public keys allowed to decrypt each secret

## Quick Start
1. Enter devshell: `nix develop`
2. Convert personal SSH key to age: `ssh-to-age < ~/.ssh/id_ed25519.pub`
3. Put that key in `secrets/secrets.nix` as `markPersonal`
4. Create a secret: `agenix -e secrets/users/mark/opencode-api-token.age`
5. Add access in `secrets/secrets.nix`
6. Use secret path in NixOS via `config.age.secrets.<name>.path`

## Adding Host Keys
On a host:
```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age
```
Add the resulting age key to `secrets/secrets.nix`, then rekey:
```bash
agenix -r
```

## Using Secrets in NixOS
Example systemd service consuming a token:
```nix
{
  feltnerm.secrets = {
    enable = true;
    hostSecrets = [ "opencode-api-token" ];
  };

  systemd.services.opencode-client = {
    script = ''
      export OPENCODE_API_KEY=$(cat ${config.age.secrets.host-opencode-api-token.path})
      # use the key
    '';
  };
}
```

## Using Secrets in Home Manager
```nix
{
  # osConfig.age.secrets.mark-opencode-api-token.path
  home.file.".config/opencode/config".text = ''
    api_key = "$(cat ${osConfig.age.secrets.mark-opencode-api-token.path})"
  '';
}
```

## Emergency Recovery
- Keep a backup of your personal SSH key
- If lost, use any host that can decrypt secrets (runtime paths under `/run/agenix`) to recover
- Rotate keys by updating `secrets/secrets.nix` and running `agenix -r`
