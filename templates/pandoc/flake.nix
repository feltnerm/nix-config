{
  # credit: https://git.sr.ht/~misterio/nix-config/tree/b7a4fa37954f0eb33f610024a43fb38137294c4f/item/templates/document/flake.nix
  description = "pandoc flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    inherit (nixpkgs.lib) genAttrs systems;
    forAllSystems = genAttrs systems.flakeExposed;
    pkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      });
  in {
    overlays = rec {
      default = _final: prev: {
        foo-bar = prev.callPackage ./. {};
      };
    };

    packages = forAllSystems (s: let
      pkgs = pkgsFor.${s};
    in rec {
      inherit (pkgs) foo-bar;
      default = foo-bar;
    });

    devShells = forAllSystems (s: let
      pkgs = pkgsFor.${s};
    in rec {
      foo-bar = pkgs.mkShell {
        inputsFrom = [pkgs.foo-bar];
      };
      default = foo-bar;
    });
  };
}
