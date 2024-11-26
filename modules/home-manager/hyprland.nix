{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.wayland.windowManager.hyprland.enable && !pkgs.stdenv.isDarwin) {
    home = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      packages = with pkgs; [
        clipse
        hyprpicker
        swww
        nwg-bar
        wl-clipboard
      ];
    };

    programs = {
      tofi = {
        enable = true;
      };
      waybar = {
        enable = true;
      };
    };

    services.mako.enable = true;

    wayland.windowManager.hyprland = {
      settings = {
        "$mod" = "SUPER";
        "exec-once" = [
          "${pkgs.waybar}/bin/waybar"
          "${pkgs.clipse}/bin/clipse -listen"
          #"${pkgs.sww}/bin/sww-daemon"
        ];
        monitor = lib.mkDefault ",highres,auto,1";
        bind = [
          "$mod, ESCAPE, exec, ${pkgs.nwg-bar}/bin/nwg-bar"
          "$mod, D, exec, ${pkgs.tofi}/bin/tofi-drun"
          "$mod, C, exec, ${pkgs.alacritty}/bin/alacritty"
          "$mod, F, exec, ${pkgs.firefox}/bin/firefox"

          "$mod, V, exec, ${pkgs.alacritty}/bin/alacritty --class clipse -e ${pkgs.clipse}/bin/clipse"
          "$mod, R, exec, ${pkgs.alacritty}/bin/alacritty --class ranger -e ${pkgs.ranger}/bin/ranger"

          #"$mod, T, exec, ${pkgs.alacritty}/bin/alacritty --class ranger -e ${pkgs.feltnerm.tmuxls-switch}/bin/tmuxls-switch"
        ];
        input = {
          kb_options = "caps:escape";
        };
      };
    };
  };
}
