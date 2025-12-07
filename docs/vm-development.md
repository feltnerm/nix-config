# VM Development

This doc covers building and running NixOS VMs for local development.

## Devshell

```sh
nix develop .#vm
```

## Build

```sh
build-vm <host> <output>
# Examples
build-vm virtmark vmWithBootLoader
build-vm virtmark-gui qcow
build-vm codemonkey iso
```

## Run

```sh
run-vm ./result --memory 4096 --cpus 2
```

## Seed SSH Keys (Cloud-init)

Quick helper:

```sh
scripts/cloud-init-seed.sh mark ~/.ssh/id_ed25519.pub seed.iso
```

Manual:

```sh
# Create user-data and meta-data, then:
cloud-localds seed.iso user-data meta-data
# Boot with VM image + seed.iso, then:
ssh -p 2222 mark@localhost
```

## Notes

- Artifacts appear at `./result` (symlink)
- SSH forwarding: `ssh -p 2222 mark@localhost`
- Acceleration: macOS (HVF) and Linux (KVM) auto-enabled when available
- Default user: `mark` (see `configs/nixos/*/user/mark.nix`)

## Direct Nix Builds (Reference)

```sh
nix build .#nixosConfigurations.<host>.config.system.build.vmWithBootLoader
nix build .#nixosConfigurations.<host>.config.system.build.vm
nix build .#nixosConfigurations.<host>.config.formats.{iso,qcow}
```
