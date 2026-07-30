/**
  nixvim configurations
*/
{ inputs, ... }:
{
  imports = [ inputs.nixvim.flakeModules.default ];

  flake.nixvimModules = {
    default = {
      imports = [
        ../modules/nixvim
      ];
    };
  };
}
