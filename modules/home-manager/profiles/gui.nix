{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.profiles.gui;
in {
  config = lib.mkIf cfg.enable {
    feltnerm.programs = {
      alacritty.enable = lib.mkDefault true;
      firefox.enable = lib.mkDefault true;
      wayland.enable = lib.mkDefault true;
    };
  };
}
