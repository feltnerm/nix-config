# feltnerm nix-config

[![CI Checks](https://github.com/feltnerm/nix-config/actions/workflows/checks-main.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/checks-main.yml)
[![VM Builds](https://github.com/feltnerm/nix-config/actions/workflows/build-vms-main.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/build-vms-main.yml)

Personal NixOS, nix-darwin, and Home Manager setup using flake-parts and a small `feltnerm` module to define hosts and users.

## Quick Start

Enable flakes: add `experimental-features = nix-command flakes` to Nix config.

- NixOS
  ```sh
  sudo nixos-rebuild switch --flake .#<hostname>
  ```
- macOS (nix-darwin) (may require `sudo`)
  ```sh
  darwin-rebuild switch --flake .#<hostname>
  ```
- Home Manager (standalone) (sort of tested)
  ```sh
  home-manager switch --flake .#<username>
  ```

## Architecture (short)

- flake-parts modules live in `flake/`
- `feltnerm` adds _my_ options
    - Shared system settings: `flake/feltnerm/system.nix`
- Custom packages: `pkgs/<name>/package.nix`

## Common Tasks

```sh
# Dev shell
nix develop

# Update inputs and commit lockfile
nix flake update --commit-lock-file

# Checks & format
nix flake check
nix fmt

# Build a package
nix build .#<pkg> && ./result/bin/<pkg>
```

## Extras

### VM Development
- Devshell: `nix develop .#vm`
- Build: `build-vm <host> <output>`
  - Examples: `build-vm virtmark vmWithBootLoader`, `build-vm virtmark-gui qcow`, `build-vm codemonkey iso`
- Run: `run-vm ./result --memory 4096 --cpus 2`
- Seed SSH keys: `seed-cloud-init mark ~/.ssh/id_ed25519.pub seed.iso`

Notes
- Artifacts appear at `./result` (symlink)
- SSH forwarding: `ssh -p 2222 mark@localhost`
- Acceleration: macOS (HVF) and Linux (KVM) auto-enabled when available
- Default user: `mark` (see `configs/nixos/*/user/mark.nix`)

Direct Nix builds (reference)
- `nix build .#nixosConfigurations.<host>.config.system.build.vmWithBootLoader`
- `nix build .#nixosConfigurations.<host>.config.system.build.vm`
- `nix build .#nixosConfigurations.<host>.config.formats.{iso,qcow}`

Cloud-init (optional)
- Quick helper: `scripts/cloud-init-seed.sh mark ~/.ssh/id_ed25519.pub seed.iso`
- Manual:
  - Create `user-data` and `meta-data`, then `cloud-localds seed.iso user-data meta-data`
  - Boot with VM image + `seed.iso`, then `ssh -p 2222 mark@localhost`

Other
- Topology: `flake.topology` outputs
- Secrets: ragenix/agenix (`age.secrets.*`, store files outside git)

## Inspiration

- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/nixos-config/
- https://git.sr.ht/~misterio/nix-config
- https://github.com/TheMaxMur/NixOS-Configuration
