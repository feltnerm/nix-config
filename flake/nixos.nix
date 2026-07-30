/**
  nixos
*/
_: {
  flake.nixosModules = {
    default = {
      imports = [
        ../modules/feltnerm
      ];
    };
  };

}
