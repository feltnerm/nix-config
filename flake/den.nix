{
  den,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.den.flakeModule
    ../modules/den/defaults.nix
  ]
  ++ lib.optional (inputs ? devshell) ./devshells.nix;

  _module.args.__findFile = den.lib.__findFile;

  den.default.includes = [ den.provides.define-user ];
}
