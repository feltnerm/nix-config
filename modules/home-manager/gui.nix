{ config, lib, ... }:
let
  cfg = config.feltnerm.home.gui;
in
{
  options.feltnerm.home.gui = {
    enable = lib.mkEnableOption "GUI home environment (Hyprland + Firefox + terminal)";
    firefoxProfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ config.home.username ];
      description = "Firefox profiles for stylix integration";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
    programs.firefox.enable = true;
    stylix.targets.firefox.profileNames = cfg.firefoxProfiles;
    programs.ghostty.enable = true;
  };
}
