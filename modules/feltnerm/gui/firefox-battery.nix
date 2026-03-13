{ config, lib, ... }:
{
  config.den.aspects.features.provides.gui.homeManager.programs.firefox.profiles.mark.settings.domPrivacy =
    lib.mkIf (config.wayland.windowManager.hyprland.enable or false) {
      "dom.battery.enabled" = false;
    };
}
