/**
  home-manager
*/
{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];

  flake.homeModules = {
    default = ../modules/home-manager;
  };
}
