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
