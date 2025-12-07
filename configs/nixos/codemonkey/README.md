# codemonkey (Desktop Workstation)

Host-specific notes for the `codemonkey` NixOS configuration. For generic installation steps, see `configs/nixos/README.md`.

## Disk Layout (disko)
Uses disko with ZFS pools/datasets defined in `hardware.nix`. Verify device IDs under `/dev/disk/by-id/`.
```bash
nix run github:nix-community/disko -- --mode zap_create_mount configs/nixos/codemonkey/hardware.nix
```

## Install Shortcut
After following the generic guide:
```bash
cd /mnt
sudo git clone https://github.com/feltnerm/nix-config
cd nix-config
sudo nixos-install --flake .#codemonkey
```
