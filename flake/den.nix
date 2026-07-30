{
  den,
  inputs,
  ...
}:
{
  imports = [
    inputs.den.flakeModule
  ];

  _module.args.__findFile = den.lib.__findFile;
}
