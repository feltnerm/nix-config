/**
  home-manager
*/
{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];

  flake.homeManagerModules = {
    default = ../modules/home-manager;
  };
}
