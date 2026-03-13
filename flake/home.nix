/**
  home-manager
*/
{ inputs, ... }:
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];
}
