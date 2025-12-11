{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.wayland.windowManager.hyprland.enable && !pkgs.stdenv.isDarwin) {
    wayland.windowManager.hyprland.systemd.enable = lib.mkDefault false;

    programs.hyprlock.enable = lib.mkDefault true;
    programs.tofi = {
      enable = lib.mkDefault true;

    };
    programs.waybar.enable = lib.mkDefault true;
    programs.waybar.systemd.enable = lib.mkDefault true;

    services.cliphist.enable = lib.mkDefault true;
    services.hypridle = {
      enable = lib.mkDefault true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            # lower brightness
            timeout = 150;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            # turn off keyboard backlight
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -sd rgb:kbd_backlight";
          }
          {
            # lock screen
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            # turn monitor off
            timeout = 300;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            # suspend OS
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    home = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      packages = with pkgs; [
        hyprpicker
        hyprsunset
        nwg-bar
        swww
        wl-clipboard-rs
      ];
    };

    services.mako.enable = lib.mkDefault true;
    wayland.windowManager.hyprland = {
      settings = {
        # variables
        "$terminal" = "ghostty";
        "$mainMod" = "super";

        "exec-once" = [
          "systemctl --user start hyprpolkitagent"
          "swww-daemon"
          "hyprsunset"
        ];

        # mouse binds
        "bindm" = [

          # resize and move windows
          "alt, mouse:272, movewindow" # NOTE: mouse:272 = left click
          "alt, mouse:273, resizewindow" # NOTE: mouse:272 = right click
        ];
        # repeatable
        "binde" = [
          # resize window
          "shift alt ctrl, h, resizeactive, -50 0"
          "shift alt ctrl, j, resizeactive, 0 50"
          "shift alt ctrl, k, resizeactive, 0 -50"
          "shift alt ctrl, l, resizeactive, 50 0"
        ];
        "bind" = [
          "ctrl alt, delete, exec, uwsm stop"
          "ctrl alt, l, exec, hyprlock" # screen lock
          "ctrl alt, p, exec, " # poweroff

          "shift alt, m, fullscreen, 1"
          "alt, f, fullscreen, 0"
          "shift alt, f, togglefloating"
          "alt ctrl, c, centerwindow"
          "alt ctrl, p, pin"

          # move focus
          "alt, h, movefocus, l"
          "alt, j, movefocus, d"
          "alt, k, movefocus, u"
          "alt, l, movefocus, r"

          # move windows
          "alt ctrl, h, movewindow, l"
          "alt ctrl, j, movewindow, d"
          "alt ctrl, k, movewindow, u"
          "alt ctrl, l, movewindow, r"

          # swap windows
          "shift alt, h, swapwindow, l"
          "shift alt, j, swapwindow, d"
          "shift alt, k, swapwindow, u"
          "shift alt, l, swapwindow, r"

          # alt tab cycling
          "alt, tab, cyclenext"
          "alt, tab, bringactivetotop"

          # workspace
          "alt, 1, workspace,1"
          "shift alt, 1, movetoworkspace,1"
          "alt, 2, workspace,2"
          "shift alt, 2, movetoworkspace,2"
          "alt, 3, workspace,3"
          "shift alt, 3, movetoworkspace,3"
          "alt, 4, workspace,4"
          "shift alt, 4, movetoworkspace,4"
          "alt, 5, workspace,5"
          "shift alt, 5, movetoworkspace,5"

          "alt, 6, workspace,6"
          "shift alt, 6, movetoworkspace,6"
          "alt, 7, workspace,7"
          "shift alt, 7, movetoworkspace,7"
          "alt, 8, workspace,8"
          "shift alt, 8, movetoworkspace,8"
          "alt, 9, workspace,9"
          "shift alt, 9, movetoworkspace,9"
          "alt, 0, workspace,10"
          "shift alt, 0, movetoworkspace,10"

          # mouse
          "alt, mouse_down, workspace, e+1"
          "alt, mouse_up, workspace, e-1"
          "ctrl, right, workspace, e+1"
          "ctrl, left, workspace, e-1"
          "shift ctrl, right, movetoworkspace, e+1"
          "shift ctrl, left, movetoworkspace, e-1"

          # Multi-monitor support (placeholder for future configuration)
          # "alt, period, focusmonitor, +1"        # Focus next monitor
          # "alt, comma, focusmonitor, -1"         # Focus previous monitor
          # "shift alt, period, movewindow, mon:+1" # Move window to next monitor
          # "shift alt, comma, movewindow, mon:-1"  # Move window to previous monitor

          # process mgmt
          "alt, q, killactive"

          # custom keybinds and launchers
          "alt, return, exec, uwsm app -- $terminal"
          "alt, escape, exec, uwsm app -- nwg-bar"
          "alt, space, exec, uwsm app -- $terminal -e $(tofi-run)"
          "shift alt, space, exec, uwsm app -- $(tofi-drun)"

          "alt, d, exec, uwsm app -- $terminal -e yazi"

          # additions to align with macOS
          "shift alt, return, layoutmsg, swapwithmaster master"
          "shift alt, p, workspace, e-1"
          "shift alt, n, workspace, e+1"
        ];
      };
    };
  };
}
