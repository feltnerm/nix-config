{
  description = "The Official feltnerm NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:yaxitech/ragenix";
    # agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs: let
    lib = import ./lib {inherit inputs;};
    inherit (lib) darwin home nixos utils;

    # default system users
    defaultUsers = [
      {
        username = "mark";
        isSudo = true;
        shell = "zsh";
      }
    ];
  in rec {
    overlays = {
      feltnerm = final: _prev: import ./packages {pkgs = final;};
      nur = inputs.nur.overlay;
    };

    systemPkgs = utils.forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config = {
          allowUnfree = true;
        };
        settings = {
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      });

    nixosModules = {
      feltnerm = import ./modules/nixos/default.nix;
    };

    homeManagerModules = {
      feltnerm = import ./modules/home-manager/default.nix;
    };

    devShells = utils.forAllSystems (system: {
      default = systemPkgs.${system}.callPackage ./shell.nix {};
    });

    formatter = utils.forAllSystems (
      system:
        systemPkgs.${system}.alejandra
    );

    hydraJobs = {
      inherit packages devShells;
      nixosConfigurations = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) nixosConfigurations;
      darwinConfigurations = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) darwinConfigurations;
      homeConfigurations = builtins.mapAttrs (_: _cfg: {}) homeConfigurations;
    };

    packages = utils.forAllSystems (system: (
      import ./packages {pkgs = systemPkgs."${system}";}
    ));

    nixosConfigurations = {
      monke = nixos.mkNixosSystem {
        hostname = "monke";
        system = "x86_64-linux";
        pkgs = systemPkgs."x86_64-linux";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
      };
    };

    darwinConfigurations = {
      "markbook" = darwin.mkDarwinSystem {
        hostname = "markbook";
        pkgs = systemPkgs."x86_64-darwin";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
      };
    };

    homeConfigurations = {
      "mark@monke" = home.mkHome {
        username = "mark";
        pkgs = systemPkgs."x86_64-linux";
        userConfig = {
          home = {
            homeDirectory = "/home/mark";
          };

          xdg.desktopEntries = {
            firefox = {
              name = "Firefox";
              genericName = "Web Browser";
              exec = "firefox %U";
              terminal = false;
              categories = ["Application" "Network" "WebBrowser"];
              mimeType = [
                "text/html"
                "text/xml"
                "application/json"
                "application/pdf"
              ];
            };
          };

          feltnerm = {
            programs = {
              firefox.enable = true;
              alacritty.enable = true;
              wayland.enable = true;
            };
          };
        };
        features = [];
      };

      "mark@markbook" = home.mkHome {
        username = "mark";
        pkgs = systemPkgs."x86_64-darwin";
        userConfig = {
          home = {
            homeDirectory = "/Users/mark";
          };
          feltnerm = {
            config.xdg.enableUserDirs = false;
            home-manager.enableAutoUpgrade = false;

            programs.git.signCommits = false;
          };
        };
        features = [];
      };

      "mfeltner@mfeltner" = home.mkHome {
        username = "mfeltner";
        userModule = ./home/mark/default.nix;
        pkgs = systemPkgs."x86_64-darwin";
        userConfig = {
          home = {
            homeDirectory = "/Users/mfeltner";
          };
          feltnerm = {
            config.xdg.enableUserDirs = false;
            home-manager.enableAutoUpgrade = false;

            programs.git.signCommits = false;
            programs.git.email = "mark.feltner@acquia.com";
            programs.gpg.pubKey = "FA9E3ABE6B2DF6521D541921CAA87B6562729B49";
            programs.keychain.keys = ["id_ecdsa_sk"];
          };
        };
        features = [];
      };
    };

    templates = import ./templates;

    # TODO
    # checks = utils.forAllSystems (system: doCheck);
  };
}
