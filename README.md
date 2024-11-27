the official feltnerm [nix](https://nixos.org/) config
----
[![Test](https://github.com/feltnerm/nixos-config/actions/workflows/checks.yml/badge.svg)](https://github.com/feltnerm/nixos-config/actions/workflows/checks.yml)

## Development

#### Update and Commit Lockfile

```shell
nix flake update --commit-lock-file
```

#### Check

```shell
nix flake check
```

#### Format

```shell
nix fmt
```

#### Packages

My (somewhat) useful custom nix packages are defined in `./pkgs`.

###### build

Locally, build them with:

```shell
nix build .#<pkg>
```

###### run

Subsequently, run them with:

```shell
./result/bin/<pkg>
```

---

## Inspiration

[![Test](https://github.com/feltnerm/nixos-config/actions/workflows/checks.yml/badge.svg)](https://github.com/feltnerm/nixos-config/actions/workflows/checks.yml)

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


