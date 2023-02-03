{
  description = "simple example flake that extends the feltnerm flake";

  inputs = {
    # source of truth for inputs
    feltnerm.url = "../../";

    # TODO ensure these follow the feltnerm nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.follows = "feltnerm/nixpkgs";

    # TODO are home-manager and darwin even needed?
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };

    # darwin = {
    #   url = "github:lnl7/nix-darwin/master";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    feltnerm,
    nixpkgs,
    # TODO needed?
    # home-manager,
    # darwin,
    ...
  }: rec {
    legacyPackages = feltnerm.lib.utils.forAllSystems (system:
      import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        #overlays = [overlay];
      });

    homeConfigurations = {
      "nix-user" = feltnerm.lib.home.mkHome {
        username = "nix-user";
        pkgs = legacyPackages."x86_64-linux";
        userModule = {};
        userConfig = {
          home = {
            stateVersion = "22.05";
            homeDirectory = "/home/test-user-01";
          };
          feltnerm = {
            config.xdg.enableUserDirs = false;
            home-manager.enableAutoUpgrade = false;
          };
        };
      };
      "darwin-user" = feltnerm.lib.home.mkHome {
        username = "darwin-user";
        pkgs = legacyPackages."x86_64-darwin";
        userModule = {};
        userConfig = {
          home = {
            stateVersion = "22.05";
            homeDirectory = "/Users/darwin-user-01";
          };
          feltnerm = {
            config.xdg.enableUserDirs = false;
            home-manager.enableAutoUpgrade = false;
          };
        };
      };
    };

    nixosConfigurations = {
      "nixos-system" = feltnerm.lib.nixos.mkNixosSystem {
        hostname = "nixos-test-host";
        pkgs = legacyPackages."x86_64-linux";
        hostModule = {};
        systemConfig = {
          # feltnerm = {};
        };
        users = [
          {
            username = "test-user-01";
            shell = "zsh";
          }
          {
            username = "test-user-02";
          }
        ];
      };
    };

    darwinConfigurations = {
      "darwin-system" = feltnerm.lib.darwin.mkDarwinSystem {
        hostname = "darwin-test-host";
        pkgs = legacyPackages."x86_64-darwin";
        hostModule = {};
        systemConfig = {
          feltnerm = {};
        };
        users = [
          {
            username = "test-user-01";
            shell = "zsh";
          }
          {
            username = "test-user-02";
          }
        ];
      };
    };
  };
}
