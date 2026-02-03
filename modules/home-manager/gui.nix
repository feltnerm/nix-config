{ config, lib, ... }:
let
  cfg = config.feltnerm.home.gui;
  firefoxProfileNames = lib.attrNames (config.feltnerm.home.firefox.profiles or {});
in
{
  options.feltnerm.home.gui = {
    enable = lib.mkEnableOption "GUI home environment (Hyprland + Firefox + terminal)";
    firefoxProfiles = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      # Auto-detect profile names from feltnerm.home.firefox.profiles; fallback to username
      default = if (firefoxProfileNames != []) then firefoxProfileNames else [ config.home.username ];
      description = "Firefox profiles for stylix integration (auto-detected).";
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland.enable = true;
    programs.firefox.enable = true;

    programs.ghostty.enable = true;
  };
}
