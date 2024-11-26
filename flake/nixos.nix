/**
  nixos
*/
_: {
  imports = [ ];

  flake.nixosModules = {
    default = ../modules/nixos;
  };

}
