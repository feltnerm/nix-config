nixos-config
----

# Usage

## System

```shell
$ nixos-rebuild --flake . <cmd>
```

## Home

```shell
% home-manager --flake . <cmd>
```

# Structure

## hosts

~~Cattle~~ Machine configurations.

## home

Users configured with `home-manager`.

## lib

`flake.nix` helpers

## modules

Modules

----

## Inspiration
- https://github.com/Xe/nixos-configs
- https://github.com/notusknot/dotfiles-nix
- https://github.com/sioodmy/dotfiles
- https://github.com/colemickens/nixcfg
- https://github.com/divnix/digga
- https://jdisaacs.com/blog/ixos-config/
- https://git.sr.ht/~misterio/nix-config
