{
  description = "feltnerm";

  nixConfig = {
    commit-lockfile-summary = "chore(flake.lock): update inputs";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [
          inputs.treefmt-nix.flakeModule
        ];

        flake =
          {
          };

        systems = [ "x86_64-darwin" "x86_64-linux" ];

        perSystem = _: {
          treefmt = {
            programs = {
              deadnix.enable = true;
              statix.enable = true;
              nixfmt.enable = true;
              mdsh.enable = true;
              shfmt.enable = true;
              shellcheck.enable = true;
            };
          };
        };
      }
    );
}
