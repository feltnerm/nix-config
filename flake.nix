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
        config = {
          allowUnfree = true;
        };
        settings = {
          substituters = [
            "https://feltnerm.cachix.org"
          ];
          trusted-public-keys = [
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
      monke = nixos.mkNixosSystem {
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
      "markbook" = darwin.mkDarwinSystem {
        hostname = "markbook";
        pkgs = legacyPackages."x86_64-darwin";
        users = defaultUsers;
        systemConfig = {
          feltnerm = {};
        };
      };

      "mfeltner" = darwin.mkDarwinSystem {
        hostname = "mfeltner";
        pkgs = legacyPackages."x86_64-darwin";
        users = [
          {
            username = "mfeltner";
            shell = "zsh";
          }
        ];
        systemConfig = {
          feltnerm = {};
        };
      };
    };

    homeConfigurations = {
      "mark@monke" = home.mkHome {
        username = "mark";
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

      "mark@markbook" = home.mkHome {
        username = "mark";
        pkgs = legacyPackages."x86_64-darwin";
        overlays = [overlays.feltnerm];
        userConfig = {
          home = {
            homeDirectory = "/Users/mark";
          };
          feltnerm = {
            config.xdg.enableUserDirs = false;
            home-manager.enableAutoUpgrade = false;

            programs.alacritty.enable = true;
            programs.git.signCommits = true;
          };
        };
        features = [];
      };

      "mfeltner@mfeltner" = home.mkHome {
        username = "mfeltner";
        userModule = ./home/mark/default.nix;
        overlays = [overlays.feltnerm];
        pkgs = legacyPackages."x86_64-darwin";
        userConfig = {
          home = {
            homeDirectory = "/Users/mfeltner";
            sessionVariables = {
              # hack to use corretto @ work
              # `/usr/libexec/java_home -v 1.8`
              JAVA_HOME = "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home";
            };
          };
          programs.keychain.keys = ["id_ecdsa_sk"];
          feltnerm = {
            config.xdg.enableUserDirs = false;
            home-manager.enableAutoUpgrade = false;

            programs.alacritty.enable = true;
            programs.git.email = "mark.feltner@acquia.com";
            programs.gpg.pubKey = "FA9E3ABE6B2DF6521D541921CAA87B6562729B49";
            programs.neovim.ui.startify.extraConfig = ''
              let g:startify_custom_header =
              \ startify#center(["                                    "]) +
              \ startify#center(["      -*++=  -*++-  +*++++++*=      "]) +
              \ startify#center(["      :#@@@+ :%@@@= =@@@@@@@%:      "]) +
              \ startify#center(["        *@@@*  #@@@+ -@@@@@*        "]) +
              \ startify#center(["         *@@@#  #@@@* :%@@=         "]) +
              \ startify#center(["          +@@@#  *@@@* :*-          "]) +
              \ startify#center(["           =@@@%: +@@@#             "]) +
              \ startify#center(["            =@@@=  +@@#:            "]) +
              \ startify#center(["             -#-    =+              "]) +
              \ startify#center(["                                    "]) +
              \ startify#center([""]) +
              \ startify#center(startify#fortune#boxed()) +
              \ startify#center([""]) +
              \ startify#center(split(system('date -R'), '\n')) +
              \ startify#center([""]) +
              \ startify#center(split(system('year-progress 100'), '\n'))
            '';
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
