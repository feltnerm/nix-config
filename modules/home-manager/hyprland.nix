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
          "$mainMod, mouse:272, movewindow" # NOTE: mouse:272 = left click
          "$mainMod, mouse:273, resizewindow" # NOTE: mouse:272 = right click
        ];
        # repeatable
        "binde" = [
          # resize window
          "$mainMod shift, h, resizeactive, -50 0"
          "$mainMod shift, j, resizeactive, 0 50"
          "$mainMod shift, k, resizeactive, 0 -50"
          "$mainMod shift, l, resizeactive, 50 0"
        ];
        "bind" = [
          "ctrl alt, delete, exec, uwsm stop"
          "CTRL ALT, L, exec, hyprlock" # screen lock
          "CTRL ALT, P, exec, " # poweroff

          "$mainMod, m, fullscreen, 1"
          "$mainMod, f, fullscreen, 0"
          "$mainMod shift, f, fullscreenstate, 0 2"
          "$mainMod ctrl, f, togglefloating"
          "$mainMod ctrl, c, centerwindow"
          "$mainMod ctrl, p, pin"

          # move focus
          "alt, h, movefocus, l"
          "alt, j, movefocus, d"
          "alt, k, movefocus, u"
          "alt, l, movefocus, r"

          # move windows
          "$mainMod ctrl, h, movewindow, l"
          "$mainMod ctrl, j, movewindow, d"
          "$mainMod ctrl, k, movewindow, u"
          "$mainMod ctrl, l, movewindow, r"

          # swap windows
          "alt, m, layoutmsg, focusmaster master"
          "$mainMod alt, m, layoutmsg, swapwithmaster master"
          "$mainMod alt, h, swapwindow, l"
          "$mainMod alt, j, swapwindow, d"
          "$mainMod alt, k, swapwindow, u"
          "$mainMod alt, l, swapwindow, r"

          # alt tab cycling
          "alt, tab, cyclenext"
          "alt, tab, bringactivetotop"

          # workspace
          "$mainMod, 1, workspace,1"
          "alt shift, 1, movetoworkspace,1"
          "$mainMod shift, 1, movetoworkspacesilent,1"
          "$mainMod, 2, workspace,2"
          "alt shift, 1, movetoworkspace,2"
          "$mainMod shift, 2, movetoworkspacesilent,2"
          "$mainMod, 3, workspace,3"
          "alt shift, 3, movetoworkspace,3"
          "$mainMod shift, 3, movetoworkspacesilent,3"
          "$mainMod, 4, workspace,4"
          "alt shift, 4, movetoworkspace,4"
          "$mainMod shift, 4, movetoworkspacesilent,4"
          "$mainMod, 5, workspace,5"
          "alt shift, 5, movetoworkspace,5"
          "$mainMod shift, 5, movetoworkspacesilent,5"

          # mouse
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod, period, workspace, e+1"
          "$mainMod, comma, workspace, e-1"
          "$mainMod, period, movetoworkspace, e+1"
          "$mainMod, comma, movetoworkspace, e-1"

          # process mgmt
          "$mainMod, q, killactive, #kill"
          "$mainMod shift, q, killactive"

          # custom keybinds and launchers
          "$mainMod, return, exec, uwsm app -- $terminal"
          "$mainMod, escape, exec, uwsm app -- nwg-bar"
          "$mainMod, space, exec, uwsm app -- $terminal -e $(tofi-run)"
          "$mainMod shift, space, exec, uwsm app -- $(tofi-drun)"

          "$mainMod, d, exec, uwsm app -- $terminal -e yazi"
        ];
      };
    };
  };
}
