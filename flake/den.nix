{ den, inputs, ... }:
{
  imports = [
    inputs.den.flakeModule
    ../modules/den/defaults.nix
    ./devshells.nix
  ];

  _module.args.__findFile = den.lib.__findFile;

  den.default.includes = [ den.provides.define-user ];
}
