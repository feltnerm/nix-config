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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
        isTrusted = true;
      }
    ];

    feltnermOverlay = final: _prev: {
      feltnerm = import ./packages {pkgs = final;};
    };
  in rec {
    lib = {
      inherit darwin home nixos utils;
    };

    overlays = rec {
      feltnerm = feltnermOverlay;
      default = feltnerm;
    };

    legacyPackages = utils.forAllSystems (system:
      import inputs.nixpkgs {
        inherit system;
        overlays = [feltnermOverlay];
        settings = {
          extra-substituters = [
            "https://feltnerm.cachix.org"
          ];
          extra-trusted-public-keys = [
            "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
          ];
        };
      });

    nixosModules = rec {
      feltnerm = import ./modules/nixos/default.nix;
      default = feltnerm;
    };

    homeManagerModules = rec {
      feltnerm = import ./modules/home-manager/default.nix;
      default = feltnerm;
    };

    darwinModules = rec {
      feltnerm = import ./modules/darwin/default.nix;
      default = feltnerm;
    };

    devShells = utils.forAllSystems (system: {
      default = legacyPackages.${system}.callPackage ./shell.nix {};
    });

    # TODO run statix as well here
    formatter = utils.forAllSystems (
      system:
        legacyPackages.${system}.alejandra
    );

    hydraJobs = {
      inherit packages devShells;
      nixosConfigurations = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) nixosConfigurations;
      darwinConfigurations = builtins.mapAttrs (_: cfg: cfg.config.system.build.toplevel) darwinConfigurations;
      homeConfigurations = builtins.mapAttrs (_: _cfg: {}) homeConfigurations;
    };

    packages = utils.forAllSystems (system: (
      import ./packages {pkgs = legacyPackages."${system}";}
    ));

    nixosConfigurations = {
      monke = inputs.nixpkgs.lib.nixosSystem (nixos.mkNixosModule {
        hostname = "monke";
        system = "x86_64-linux";
        pkgs = legacyPackages."x86_64-linux";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
        homeManagerUsers = [
          {
            username = "mark";
            userConfig = {
              feltnerm = {
                programs = {
                  alacritty.enable = true;
                  firefox.enable = true;
                  hyprland.enable = true;
                };
              };

              wayland.windowManager.hyprland.settings.monitor = "HDMI-A-2,3840x2160@30,0x0,1";

              xdg = {
                userDirs.enable = true;
                desktopEntries = {
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
              };
            };
          }
        ];
      });
    };

    darwinConfigurations = {
      "markbook" = inputs.darwin.lib.darwinSystem (darwin.mkDarwinModule {
        hostname = "markbook";
        pkgs = legacyPackages."x86_64-darwin";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
        homeManagerUsers = [
          {
            username = "mark";
            userConfig = {
              feltnerm = {
                programs.alacritty.enable = true;
              };
            };
          }
        ];
      });
    };

    homeConfigurations = {};

    templates = import ./templates;

    # TODO
    # checks = utils.forAllSystems (system: doCheck);
  };
}
