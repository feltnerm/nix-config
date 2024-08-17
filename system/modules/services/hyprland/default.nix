{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.services.hyprland;
in {
  options.feltnerm.services.hyprland = {
    enable = lib.mkEnableOption "hyprland";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver.enable = false;
    };

    programs.hyprland.enable = true;

    # TODO security.pam.services.swaylock = {};
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
  };
}
