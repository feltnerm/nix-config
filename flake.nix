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
    inherit (lib) mkNixosSystem mkDarwinSystem mkHome forAllSystems;

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
      nur = inputs.nur.overlay;
      # TODO
      # default = import ./overlay {inherit inputs;};
      # unstable = inputs.unstable.overlay;
    };

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config.allowUnfree = true;
      });

    nixosModules = {
      feltnerm = import ./modules/nixos/default.nix;
    };

    homeManagerModules = {
      feltnerm = import ./modules/home-manager/default.nix;
    };

    devShells = forAllSystems (system: {
      default = legacyPackages.${system}.callPackage ./shell.nix {};
    });

    formatter = forAllSystems (
      system:
        legacyPackages.${system}.alejandra
    );

    hydraJobs = {
      nixosConfigurations = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) nixosConfigurations;
      darwinConfigurations = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) darwinConfigurations;
      homeConfigurations = builtins.mapAttrs (_: cfg: {}) homeConfigurations;
      inherit packages;
    };

    packages = forAllSystems (system: (
      import ./packages {pkgs = legacyPackages."${system}";}
    ));

    nixosConfigurations = {
      monke = mkNixosSystem {
        hostname = "monke";
        system = "x86_64-linux";
        pkgs = legacyPackages."x86_64-linux";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
      };
    };

    darwinConfigurations = {
      "markbook" = mkDarwinSystem {
        hostname = "markbook";
        pkgs = legacyPackages."x86_64-darwin";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
      };
    };

    homeConfigurations = {
      "mark@monke" = mkHome {
        username = "mark";
        hostname = "monke";
        pkgs = legacyPackages."x86_64-linux";
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

      "mark@markbook" = mkHome {
        username = "mark";
        hostname = "markbook";
        pkgs = legacyPackages."x86_64-darwin";
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
    };

    nixConfig = {
      extra-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      extra-trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # TODO
    # templates = import ./templates;
    # checks = forAllSystems (system: doCheck);
  };
}
