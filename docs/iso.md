# ISOs

Generic instructions for building bootable ISO images from hosts.

## Overview
- ISO outputs are provided via flake formats for supported hosts
- Useful for installs, rescue environments, and demos

## Build ISO
```sh
# Direct flake build
nix build .#nixosConfigurations.<host>.config.formats.iso

# Using helper (if available)
build-vm <host> iso
```
Artifacts appear at `./result`.

## Usage
- Write ISO to USB: `nix run nixpkgs#usbimager -- --log --silent ./result <device>` or use `dd`/Etcher
- Boot on hardware or inside a VM

## Cloud-init (optional)
Attach a seed ISO to inject SSH keys:
```sh
scripts/cloud-init-seed.sh mark ~/.ssh/id_ed25519.pub seed.iso
# When running a VM: add `-cdrom seed.iso` or use `run-vm` option
```

## Host-specific notes
- For GUI ISOs, see `livecds.md`
- For install steps, see `hosts.md`
