/**
  nixos
*/
_: {
  imports = [ ];

  flake.nixosModules = {
    default = ../modules/nixos;
    vm-base = ../modules/nixos/vm-base.nix;
    live-iso = ../modules/nixos/live-iso.nix;
    wsl-base = ../modules/nixos/wsl-base.nix;
  };

}
