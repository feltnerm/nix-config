{
  description = "The Official feltnerm Flake";

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
    # nur.url = "github:nix-community/NUR";

    # TODO styling
    # stylix.url = "github:danth/stylix";

    # TODO impermanence
    # impermanence.url = "github:/nix-community/impermanence";

    # TODO disko
    # disko = {
    #   url = "github:nix-community/disko";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO sops
    #sops-nix.url = "github:Mic92/sops-nix";

    # TODO secrets
    # secrets.url = "github:feltnerm/secrets";
    # agenix.url = "github:yaxitech/ragenix";
    # agenix.url = "github:ryantm/agenix";

    # TODO generators
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO render docs
    # nmd.url = "github:gvolpe/nmd";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    flake-parts,
    ...
  } @ inputs: let
    stateVersion = "24.11";
    stateVersionDarwin = 4;
    lib = import ./lib {inherit self inputs stateVersion stateVersionDarwin;};

    # TODO
    # feltnermOverlay = final: _prev: {
    #   feltnerm = import ./pkgs {pkgs = final;};
    # };

    hosts = {
      monke = {
        hostname = "monke";
        username = "mark";
        platform = "x86_64-linux";
      };
      markbook = {
        hostname = "markbook";
        username = "mark";
        platform = "x86_64-darwin";
      };
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      flake = {
        nixosConfigurations = {
          ${hosts.monke.hostname} = lib.mkHost hosts.monke;
        };

        darwinConfigurations = {
          ${hosts.markbook.hostname} = lib.mkHostDarwin hosts.markbook;
        };

        # TODO
        # overlays = {
        #   feltnerm = feltnermOverlay;
        # };

        # TODO
        # nixosModules = {};
        # darwinModules = {};
        # homeManagerModules = {};
      };

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      # TODO
      perSystem = {pkgs, ...}: {
        devShells.default = import ./shell.nix {inherit pkgs;};
        formatter = pkgs.alejandra;
        packages = import ./pkgs {inherit pkgs;};
      };
    };
}
