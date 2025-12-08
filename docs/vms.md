# VMs

Generic instructions for building, running, and using NixOS VM artifacts produced by this repo.

## Overview
- VM types: `vm`, `vmWithBootLoader`, `qcow` images via flake outputs
- Helpers: `build-vm <host> <output>`, `run-vm <image> [opts]`
- Default user: `mark` (override per host under `configs/*/user/mark.nix`)

## Devshell
```sh
nix develop .#vm
```
Provides `build-vm` and `run-vm` helpers plus `qemu-system-*` tools.

## Build VM Artifacts
```sh
# Generic helper
build-vm <host> <output>

# Examples
build-vm virtmark vmWithBootLoader
build-vm virtmark-gui qcow
build-vm codemonkey iso
```

Direct flake builds (reference):
```sh
nix build .#nixosConfigurations.<host>.config.system.build.vmWithBootLoader
nix build .#nixosConfigurations.<host>.config.system.build.vm
nix build .#nixosConfigurations.<host>.config.formats.qcow
```

## Run VM
```sh
run-vm ./result --memory 4096 --cpus 2
```
Common options:
- `--memory <MB>`: RAM size
- `--cpus <N>`: vCPU count
- `--ssh 2222`: enable host port forward to guest SSH

## SSH Access
```sh
ssh -p 2222 mark@localhost
```
Use after running with SSH port forwarding enabled.

## Cloud-init Seeding (SSH keys)
Quick helper:
```sh
scripts/cloud-init-seed.sh mark ~/.ssh/id_ed25519.pub seed.iso
```
Manual:
```sh
# Prepare user-data and meta-data
cloud-localds seed.iso user-data meta-data
# Boot VM image with seed.iso attached
# Then SSH as:
ssh -p 2222 mark@localhost
```

## Notes
- Artifacts appear at `./result` symlink
- Acceleration: macOS (HVF) and Linux (KVM) auto-enabled when available
- For host-specific tweaks, consult `configs/nixos/<host>/README.md`
