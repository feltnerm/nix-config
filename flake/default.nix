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
