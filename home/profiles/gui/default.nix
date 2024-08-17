{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.profiles.gui;
in {
  options.feltnerm.profiles.gui = {
    enable = lib.mkEnableOption "gui";
  };

  config =
    lib.mkIf cfg.enable {
    };
}
