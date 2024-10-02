{
  description = "The Official feltnerm Flake";

  nixConfig = {
    # extra-substituters =
    #   "https://nix-community.cachix.org https://foo-dogsquared.cachix.org";
    # extra-trusted-public-keys =
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= foo-dogsquared.cachix.org-1:/2fmqn/gLGvCs5EDeQmqwtus02TUmGy0ZlAEXqRE70E=";
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

    # TODO deploys
    # deploy.url = "github:serokell/deploy-rs";
    # deploy.inputs.nixpkgs.follows = "nixpkgs";

    # TODO generators
    # nixos-generators = {
    #   url = "github:nix-community/nixos-generators";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # TODO render docs
    # nmd.url = "github:gvolpe/nmd";

    ## TODO Make a Neovim distro.
    #nixvim.url = "github:nix-community/nixvim";
    #nixvim.inputs.nixpkgs.follows = "nixpkgs";
    #nixvim.inputs.home-manager.follows = "home-manager";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-parts,
    ...
  } @ inputs: let
    stateVersion = "24.11";
    stateVersionDarwin = 4;
    lib = import ./lib {inherit self inputs stateVersion stateVersionDarwin;};

    hosts = {
      monke = {
        hostname = "monke";
        username = "mark";
        platform = "x86_64-linux";
      };
      markbook = {
        username = "mark";
        hostname = "markbook";
        platform = "x86_64-darwin";
      };
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} ({ withSystem, ... }: {
      imports = [
        # inputs.flake-parts.flakeModules.easyOverlay
        # inputs.flake-parts.flakeModules.modules
        # ({ withSystem, ... }: {

        # })
      ];

      flake = {
        nixosConfigurations = {
          ${hosts.monke.hostname} = lib.mkHost hosts.monke;
        };

        darwinConfigurations = {
          ${hosts.markbook.hostname} = lib.mkHostDarwin hosts.markbook;
        };

        overlays = {
          # nixpkgs-stable = final: prev: {
          #   nixpkgs-stable = inputs.nixpkgs-stable.legacyPackages.${prev.system};
          # };
          # nixpkgs-master = final: _: {
          #   nixpkgs-master = inputs.nixpkgs-master.legacyPackages.${prev.system};
          # };
          # feltnerm = final: _: {
          #   feltnerm = import ./pkgs {inherit final;};
          # };
          # feltnerm = final: prev:
          #   withSystem prev.stdenv.hostPlatform.system (
          #     # perSystem parameters. Note that perSystem does not use `final` or `prev`.
          #     { config, ... }: {
          #         feltnerm = import ./pkgs {pkgs = config.packages;};
          #     });
        };

        # modules.nixos = ./system/modules;
        # modules.darwin = ./system/modules/darwin;
        # modules.homeManager = ./home/modules;

        # TODO
        # nixosModules = {};
        # darwinModules = {};
        # homeManagerModules = {};
      };

      systems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devShells.default = import ./shell.nix {inherit pkgs;};
        formatter = pkgs.alejandra;
        packages = import ./pkgs {inherit pkgs;};

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.allowUnfreePredicate = _: true;
        };

      };
    });
}
