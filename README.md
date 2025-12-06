# feltnerm nix-config

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

- VM images: `nixosConfigurations.<host>.config.formats.<format>`
- Topology diagrams: build outputs under `flake.topology`
- TODO Secrets: use ragenix/agenix (`age.secrets.*`, store files outside git)

## Inspiration

- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/nixos-config/
- https://git.sr.ht/~misterio/nix-config
- https://github.com/TheMaxMur/NixOS-Configuration
