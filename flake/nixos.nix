/**
  nixos
*/
_: {
  imports = [ ];

  flake.nixosModules = {
    default = {
      imports = [
        ../modules/defaults.nix
      ];
    };
    vm-base = ../modules/nixos/vm-base.nix;
    live-iso = ../modules/nixos/live-iso.nix;
    wsl-base = ../modules/nixos/wsl-base.nix;
  };

}
