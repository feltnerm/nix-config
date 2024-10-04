{
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.profiles.gui;
in
{
  config =
    lib.mkIf cfg.enable
      {
      };
}
