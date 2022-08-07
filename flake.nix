{
  description = "The Official feltnerm NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      # use home-manager pinned to 22.05, our nixpkgs version.
      url = "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";

      # TODO use unstable?
      # url = "github:nix-community/home-manager";
    };

    # TODO
    # nixpkgs-darwin-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixos";
    # nixos-hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = inputs: let
    lib = import ./lib {inherit inputs;};
    inherit (lib) mkSystem mkHome forAllSystems;
  in rec {
    inherit lib;

    overlays = {
      # default = import ./overlay {inherit inputs;};
      # unstable = inputs.unstable.overlay;
      # nur = inputs.nur.overlay;
    };

    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # TODO
    # templates = import ./templates;

    devShells = forAllSystems (system: {
      default = legacyPackages.${system}.callPackage ./shell.nix {};
    });

    legacyPackages = forAllSystems (
      system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
    );

    # default system users
    defaultUsers = [
      {
        username = "mark";
        uid = 1000;
        groups = ["@wheel"];
        # TODO share user and system packages
        pkgs = legacyPackages."x86_64-linux";
      }
    ];

    nixosConfigurations = {
      monke = mkSystem {
        hostname = "monke";
        pkgs = legacyPackages."x86_64-linux";
        users = defaultUsers;
        systemConfig = {};
      };

      # # TODO raspberry pi 3 server
      # secupi = mkSystem {
      #   hostname = "secupi";
      #   pkgs = legacyPackages."aarch64-linux";
      # }
    };

    homeConfigurations = {
      "mark@monke" = mkHome {
        username = "mark";
        hostname = "monke";
        userConfig = {};
        features = [];
        # TODO add more configuration definitions here.
      };

      "kram@monke" = mkHome {
        username = "kram";
        hostname = "monke";
      };

      # # TODO raspberry pi server
      # "mark@secupi" = mkHome {
      #   username = "mark";
      #   hostname = "secupi";
      # };

      # # TODO work + darwin
      # "mfeltner@mfeltner" = mkHome {
      #   username = "mfeltner";
      #   hostname = "mfeltner";
      # };
    };
  };
}
