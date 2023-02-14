{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.gui;
in {
  imports = [];

  options.feltnerm.gui = {
    enable = lib.mkOption {
      description = "Enable pre-customized GUI.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    feltnerm = {
      programs = {
        alacritty.enable = lib.mkDefault true;
        firefox.enable = lib.mkDefault true;
        gpg.enableAgent = lib.mkDefault true;
        wayland.enable = lib.mkDefault true;
      };
    };
  };
}
