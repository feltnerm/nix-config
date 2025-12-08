# feltnerm nix-config

[![CI Checks](https://github.com/feltnerm/nix-config/actions/workflows/checks-main.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/checks-main.yml)
[![VM Builds](https://github.com/feltnerm/nix-config/actions/workflows/build-vms-main.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/build-vms-main.yml)
[![GH Pages](https://github.com/feltnerm/nix-config/actions/workflows/gh-pages.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/gh-pages.yml)
[![Update flake.lock](https://github.com/feltnerm/nix-config/actions/workflows/update-flake-lock.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/update-flake-lock.yml)

Personal NixOS, nix-darwin, and Home Manager setup using flake-parts and a small `feltnerm` module to define hosts and users.

## Quick Start

- See system guides under `configs/`:
  - [NixOS](configs/nixos/README.md): `configs/nixos/README.md`
  - [macOS](configs/darwin/README.md) (nix-darwin): `configs/darwin/README.md`
  - [Home Manager](/configs/home/README.md) `configs/home/README.md`

## Common Tasks

### Development
```sh
# Enter dev shell
nix develop

# Update inputs and commit lockfile
nix flake update --commit-lock-file
```

### Formatting & Checks
```sh
# Run flake checks
nix flake check

# Format with treefmt
nix fmt
```

### Packages
```sh
# Build a package
nix build .#<pkg>
# Run the built binary (if applicable)
./result/bin/<pkg>
```

## VM Development

See `docs/vm-development.md` for detailed VM build/run instructions.

## Inspiration

- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/nixos-config/
- https://git.sr.ht/~misterio/nix-config
- https://github.com/TheMaxMur/NixOS-Configuration
