{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.flakeModules.default
  ];

  config = {
    nixvim = {
      packages.enable = true;
      checks.enable = true;
    };

    flake.nixvimModules = {
      # default = ../modules/nixvim;
    };
  };
}
