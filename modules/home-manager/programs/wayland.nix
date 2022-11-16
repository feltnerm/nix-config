{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.wayland;
in {
  options.feltnerm.programs.wayland = {
    enable = lib.mkOption {
      description = "Enable wayland.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      waybar = {
        enable = true;
        systemd.enable = true;
        systemd.target = "sway-session.target";
      };
    };

    wayland.windowManager.sway = {
      # FIXME
      enable = lib.mkIf cfg.enable;
      config = {
        menu = "${pkgs.wofi}/bin/wofi --show drun";
        terminal = "${pkgs.alacritty}/bin/alacritty";
      };
      extraConfig = ''
        output HDMI-A-2 scale 2
        output HDMA-A-2 pos 0 0 res 3440x1440

        input "type:keyboard" {
          xkb_options caps:escape
        }

        set $cursor_size 54

        set $gnome-schema org.gnome.desktop.interface
        exec_always {
          gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
        }

        seat seat0 xcursor_theme breeze 54

        #exec swayidle -w \
        #  timeout 1800 'swaylock -f'
        #  timeout 1805 'swaymsg "output * dpms off"' \
        #  resume 'swaymsg "output * dpms on"'

        exec dbus-sway-environment
        exec configure-gtk
      '';
      wrapperFeatures = {
        gtk = true;
      };
    };

    services.swayidle.enable = lib.mkIf cfg.enable;
  };
}
