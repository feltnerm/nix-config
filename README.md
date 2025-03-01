the official feltnerm [nix](https://nixos.org/) config
----

[![checks](https://github.com/feltnerm/nix-config/actions/workflows/checks.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/checks.yml)

[![update-flake-lock](https://github.com/feltnerm/nix-config/actions/workflows/update-flake-lock.yml/badge.svg)](https://github.com/feltnerm/nix-config/actions/workflows/update-flake-lock.yml)

## Development

### Development Shell

```shell
nix develop
```

### Update and Commit Lockfile

```shell
nix flake update --commit-lock-file
```

### Check

```shell
nix flake check
```

### Format

```shell
nix fmt
```

## Hosts

### nixos

```shell
nixos-rebuild --flake '.#<hostname> <check|build|switch>'
```

### darwin

```shell
darwin-rebuild --flake '.#<hostname> <check|build|switch>'
```

### build vm

Uses [nixos-generators](https://github.com/nix-community/nixos-generators).

```shell
nix build .#nixosConfigurations.<hostName>.config.formats.<format>
```

### generate topology diagram

Uses [nix-topology](https://oddlama.github.io/nix-topology).

#### Linux

```shell
nix build .#topology.x86_64-linux.config.output
```

#### macOS

```shell
nix build .#topology.x86_64-darwin.config.output
```

## home-manager

```shell
home-manager --flake '.#<username> <build|switch>'
```

## nixvim

```shell
nix run .# -- <file>
```

```shell
nix run .#<name>-nvim -- <file>
```

## Packages

My (somewhat) useful custom nix packages are defined in `./pkgs`.

### build

Locally, build them with:

```shell
nix build .#<pkg>
```

### run

Subsequently, run them with:

```shell
./result/bin/<pkg>
```

---

## Inspiration

<small>
Inspired by the following (and many others!):

- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/ixos-config/
- https://git.sr.ht/~misterio/nix-config
- https://github.com/TheMaxMur/NixOS-Configuration
</small>


