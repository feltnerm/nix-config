{
  ...
}:
{
  imports = [
    ./feltnerm

    ./darwin.nix
    ./devshells.nix
    ./flake-modules.nix
    ./home.nix
    ./nixos.nix
    ./nixvim.nix
    ./pkgs.nix
    ./topology.nix
    ./treefmt.nix
  ];

  feltnerm = {
    nixvim = {
      configs = {
        feltnerm-nvim = {
          modules = [ ../configs/nixvim ];
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
                {
                  extraGroups = [
                    "wheel"
                    "audio"
                    "disk"
                    "input"
                    "network"
                    "networkmanager"
                    "systemd-journal"
                    "video"
                  ];
                  initialHashedPassword = "$6$2NK82jaDKvjvsrCb$ob7K1mkNsBKy75a4aB5kzNFtQt1QSvlRTPeLlLwAkgPfp2eAgIfLds147MflimRdbHP8ErNoOkG9pUMFNoKua0";
                }
              ];
              home = {
                modules = [
                  ../configs/home/mark
                  # ./configs/home/mark/gui.nix
                ];
              };
            };
          };
        };
      };
    };

    darwin = {
      hosts = {
        markbook = {
          modules = [
            ../configs/darwin/markbook
          ];
          users = {
            mark = {
              home = {
                modules = [
                  ../configs/home/mark
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
