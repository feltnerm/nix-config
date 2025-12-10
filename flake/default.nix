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

    conventions = {
      configsPath = ../configs;
    };

    nixos = {
      hosts = {
        codemonkey = {
          users = {
            mark = {
              home = {
                modules = [ { feltnerm.theme = lib.mkForce "catppuccin-mocha"; } ];
              };
            };
          };
        };

        markbook = {
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
        virtmark = { };
        virtmark-gui = { };
      };

      livecds = {
        livecd = { };
        livecd-gui = { };
      };
    };

    home = {
      users = {
        mark = { };
      };
    };

    nixvim = {
      configs = {
        feltnerm-nvim = {
          modules = [ ../modules/home-manager/nixvim.nix ];
        };
      };
    };
  };
}
