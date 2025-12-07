# feltnerm nix-config

[![CI Checks](https://github.com/feltnerm/nix-config/actions/workflows/checks-main.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/checks-main.yml)
[![VM Builds](https://github.com/feltnerm/nix-config/actions/workflows/build-vms-main.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/build-vms-main.yml)
[![Update flake.lock](https://github.com/feltnerm/nix-config/actions/workflows/update-flake-lock.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/update-flake-lock.yml)

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

### Topology
```sh
# Build topology output via flake-parts (SVG)
# Uses perSystem.topology from flake/topology.nix
nix build .#topology.$(nix eval --raw --expr 'builtins.currentSystem').config.output
# Result symlink at ./result (e.g., ./result/topology.svg)
```
- Source: `flake/topology.nix:1`

### Secrets (agenix/ragenix)
```sh
# Edit a secret
nix run github:yaxitech/ragenix -- -e path/to/secret.age

# Rekey secrets after adding/removing recipients
nix run github:yaxitech/ragenix -- -r
```
- Store `.age` files outside git; keep recipients updated.

## VM Development

See `docs/vm-development.md` for detailed VM build/run instructions.

## Extras

- Topology: `flake.topology` outputs
- Secrets: ragenix/agenix (`age.secrets.*`, store files outside git)`

## Inspiration

- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/nixos-config/
- https://git.sr.ht/~misterio/nix-config
- https://github.com/TheMaxMur/NixOS-Configuration
