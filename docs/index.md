nix-config
----

# Quick Start

Assuming you already have a nix system, pop into a shell with:

<!-- TODO test this -->
```shell
% nix develop github.com/feltnerm/nix-config
```

## Local Usage

```shell
% nix develop
```

## System

```shell
$ nixos-rebuild --flake '.#<host>' <cmd>
```

Example: `sudo nixos-rebuild --flake '.#monke' switch`

## macOS

```shell
$ darwin-rebuild --flake '.#<host>'> <cmd>
```

Example: `sudo nixos-rebuild --flake '.#markbook' switch`

## Home

```shell
% home-manager --flake '.#<user>' <cmd>
```

Example: `home-manager --flake '.#mark@monke' switch`

# Structure

## hosts

~~Cattle~~ Machine configurations.

## home

Users configured with `home-manager`.

## lib

`flake.nix` helpers

## modules

Modules

- darwin        - modules for nix-darwin
- home-manager  - modules for home-manager
- common        - for modules shared between darwin/home-manager/nixos

----

## Inspiration
- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/ixos-config/
- https://git.sr.ht/~misterio/nix-config
