{
  lib,
  ...
}:
{
  imports = [
    ./feltnerm

    ./darwin.nix
    ./devshells.nix
    ./flake-modules.nix
    ./home.nix
    ./overlays.nix
    ./nixos.nix
    ./nixvim.nix
    ./pkgs.nix
    ./topology.nix
    ./treefmt.nix
    ./isos.nix
  ];

  feltnerm = {
    nixvim = {
      configs = {
        feltnerm-nvim = {
          modules = [ ../modules/home-manager/nixvim.nix ];
        };
      };
    };

    conventions = {
      configsPath = ../configs/nixos;
      homeConfigsPath = ../configs/home;
    };

    nixos = {

      hosts = {
        codemonkey = {
          system = "x86_64-linux";
          users = {
            mark = {
              home = {
                modules = [ { feltnerm.theme = lib.mkForce "catppuccin-mocha"; } ];
              };
            };
          };
        };

        markbook = {
          system = "x86_64-linux";
          users = {
            mark = {
              home = {
                modules = [ { feltnerm.theme = lib.mkForce "catppuccin-latte"; } ];
              };
            };
          };
        };
      };

      wsl = {
        reddevil = {
          system = "x86_64-linux";
          users = {
            mark = {
              home = {
                modules = [ { feltnerm.theme = lib.mkForce "catppuccin-macchiato"; } ];
              };
            };
          };
        };
      };

      vms = {
        virtmark = {
          system = "x86_64-linux";
        };
        virtmark-gui = {
          system = "x86_64-linux";
        };
      };

      livecds = {
        livecd = {
          system = "x86_64-linux";
        };
        livecd-gui = {
          system = "x86_64-linux";
        };
      };
    };

    home = {
      users = {
        mark = {
          modules = [
            ../configs/home/mark
          ];
        };
      };
    };
  };
}
