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

    nixos = {
      hosts = {
        codemonkey = {
          modules = [ ../configs/nixos/codemonkey ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/codemonkey/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/codemonkey/home/mark.nix
                  { feltnerm.theme = lib.mkForce "catppuccin-mocha"; }
                ];
              };
            };
          };
        };

        markbook = {
          modules = [ ../configs/nixos/markbook ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/markbook/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/markbook/home/mark.nix
                  { feltnerm.theme = lib.mkForce "catppuccin-latte"; }
                ];
              };
            };
          };
        };

      };
      wsl = {
        reddevil = {
          modules = [
            ../configs/nixos/reddevil
          ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/reddevil/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/reddevil/home/mark.nix
                  { feltnerm.theme = lib.mkForce "catppuccin-macchiato"; }
                ];
              };
            };
          };
        };
      };
      vms = {
        virtmark = {
          modules = [
            ../configs/nixos/virtmark
          ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/virtmark/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/virtmark/home/mark.nix
                ];
              };
            };
          };
        };
        virtmark-gui = {
          modules = [
            ../configs/nixos/virtmark-gui
          ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/virtmark-gui/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/virtmark-gui/home/mark.nix
                ];
              };
            };
          };
        };
      };
      livecds = {
        livecd = {
          modules = [
            ../configs/nixos/livecd
          ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/livecd/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/livecd/home/mark.nix
                ];
              };
            };
          };
        };
        livecd-gui = {
          modules = [
            ../configs/nixos/livecd-gui
          ];
          users = {
            mark = {
              modules = [
                ../configs/nixos/livecd-gui/user/mark.nix
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  ../configs/nixos/livecd-gui/home/mark.nix
                ];
              };
            };
          };
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
