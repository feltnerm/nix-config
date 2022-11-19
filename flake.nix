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
    inherit (lib) mkSystem mkHome forAllSystems;

    # default system users
    defaultUsers = [
      {
        username = "mark";
        uid = 1000;
        groups = [
          "wheel"
          "disk"
          "audio"
          "video"
          "input"
          "systemd-journal"
          "networkmanager"
          "network"
        ];
      }
    ];
  in rec {
    overlays = {
      # default = import ./overlay {inherit inputs;};
      # unstable = inputs.unstable.overlay;
      nur = inputs.nur.overlay;
    };

    nixosModules = {
      feltnerm = import ./modules/nixos/default.nix;
    };

    homeManagerModules = {
      feltnerm = import ./modules/home-manager/default.nix;
    };

    # TODO
    # templates = import ./templates;

    # checks = forAllSystems (system: doCheck);

    devShells = forAllSystems (system: {
      default = legacyPackages.${system}.callPackage ./shell.nix {};
    });

    formatter = forAllSystems (
      system:
        legacyPackages.${system}.alejandra
    );

    legacyPackages = forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        overlays = builtins.attrValues overlays;
        config.allowUnfree = true;
      });

    nixosConfigurations = {
      monke = mkSystem {
        hostname = "monke";
        system = "x86_64-linux";
        pkgs = legacyPackages."x86_64-linux";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
      };

      markbook = mkSystem {
        hostname = "markbook";
        system = "x86_64-darwin";
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
  };
}
