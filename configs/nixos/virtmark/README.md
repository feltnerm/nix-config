# virtmark (Headless VM)

## VM Image Build
You can build a QCOW2 image via flake outputs:
```bash
nix build .#images.virtmark.qcow2
```

## Install Shortcut (manual)
After following the generic guide for partitioning and mounting:
```bash
cd /mnt
sudo git clone https://github.com/feltnerm/nix-config
cd nix-config
sudo nixos-install --flake .#virtmark
```
