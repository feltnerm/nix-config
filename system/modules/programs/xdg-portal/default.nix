{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.programs.xdg-portal;
in {
  options.feltnerm.programs.xdg-portal = {
    enable = lib.mkEnableOption "xdg-portal";
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      wlr.enable = true;
      config = {
        common = {
          default = "*";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
  };
}
