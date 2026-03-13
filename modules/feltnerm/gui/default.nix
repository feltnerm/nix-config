_: {
  imports = [ ./firefox-battery.nix ];

  config.den.aspects.features.provides.gui = {
    nixos =
      { pkgs, lib, ... }:
      lib.mkMerge [
        {
          services.greetd.enable = true;
          programs.hyprland = {
            enable = true;
            withUWSM = lib.mkDefault true;
          };
          programs.hyprlock.enable = true;
          security.pam.services.hyprlock = { };
          environment.systemPackages = lib.mkDefault (
            with pkgs;
            [
              xdg-utils
              kitty
            ]
          );
        }
        {
          environment.systemPackages = with pkgs; [
            xdg-utils
          ];
        }
        # hyprland extras
        {
          programs.hyprlock.enable = true;
          security.pam.services.hyprlock = { };
          services.hypridle.enable = true;

          security.polkit.enable = true;
          services.gnome.gnome-keyring.enable = true;

          xdg.portal = {
            enable = lib.mkDefault true;
            wlr.enable = true;
            extraPortals = with pkgs; [
            ];
          };

          # uwsm
          programs.uwsm = {
            enable = lib.mkDefault true;
            waylandCompositors = {
              hyprland = {
                prettyName = "Hyprland";
                comment = "Hyprland compositor managed by UWSM";
                binPath = lib.mkDefault "/run/current-system/sw/bin/Hyprland";
              };
            };
          };

          services.xserver.enable = lib.mkDefault false;

          # greeter
          programs.regreet.enable = lib.mkDefault true;
          services.greetd = {
            restart = lib.mkDefault true;
            settings =
              let
                hyprlandConf = pkgs.writeTextFile {
                  name = "hyprland.conf";
                  text = ''
                    exec-once = regreet; uwsm stop
                    misc {
                        disable_hyprland_logo = true
                        disable_splash_rendering = true
                        disable_hyprland_qtutils_check = true
                    }
                  '';
                };
              in
              {
                user = "greeter";
                command = "Hyprland --config ${hyprlandConf}";
              };
          };
        }
        # fonts
        {
          fonts.packages = with pkgs; [
            # sans fonts
            comic-neue
            source-sans

            # monospace
            nerd-fonts.hack
            nerd-fonts.jetbrains-mono
            nerd-fonts.iosevka
            nerd-fonts.blex-mono
          ];

          fonts.enableDefaultPackages = lib.mkDefault true;

          fonts.fontconfig = {
            defaultFonts = {
              monospace = [
                "Iosevka Term Nerd Font Complete Mono"
                "Iosevka Nerd Font"
                "Noto Color Emoji"
              ];
              sansSerif = [
                "Iosevka Nerd Font"
                "Noto Color Emoji"
              ];
              serif = [
                "Iosevka Nerd Font"
                "Noto Color Emoji"
              ];
              emoji = [ "Noto Color Emoji" ];
            };
          };
        }
      ];

    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      lib.mkMerge [
        # hyprland keybinds and configuration
        {
          wayland.windowManager.hyprland = lib.mkIf (!pkgs.stdenv.isDarwin) {
            enable = lib.mkDefault true;
            systemd.enable = lib.mkDefault false;
            configType = lib.mkDefault "hyprlang";
            settings = {
              "$terminal" = "ghostty";
              "$mainMod" = "super";
              "exec-once" = [
                "systemctl --user start hyprpolkitagent"
                "awww-daemon"
                "hyprsunset"
              ];
              "bindm" = [
                "alt, mouse:272, movewindow"
                "alt, mouse:273, resizewindow"
              ];
              "binde" = [
                "shift alt ctrl, h, resizeactive, -50 0"
                "shift alt ctrl, j, resizeactive, 0 50"
                "shift alt ctrl, k, resizeactive, 0 -50"
                "shift alt ctrl, l, resizeactive, 50 0"
              ];
              "bind" = [
                "ctrl alt, delete, exec, uwsm stop"
                "ctrl alt, l, exec, hyprlock"
                "ctrl alt, p, exec, "
                "shift alt, m, fullscreen, 1"
                "alt, f, fullscreen, 0"
                "shift alt, f, togglefloating"
                "alt ctrl, c, centerwindow"
                "alt ctrl, p, pin"
                "alt, h, movefocus, l"
                "alt, j, movefocus, d"
                "alt, k, movefocus, u"
                "alt, l, movefocus, r"
                "alt ctrl, h, movewindow, l"
                "alt ctrl, j, movewindow, d"
                "alt ctrl, k, movewindow, u"
                "alt ctrl, l, movewindow, r"
                "shift alt, h, swapwindow, l"
                "shift alt, j, swapwindow, d"
                "shift alt, k, swapwindow, u"
                "shift alt, l, swapwindow, r"
                "alt, tab, cyclenext"
                "alt, tab, bringactivetotop"
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
                "alt, mouse_down, workspace, e+1"
                "alt, mouse_up, workspace, e-1"
                "ctrl, right, workspace, e+1"
                "ctrl, left, workspace, e-1"
                "shift ctrl, right, movetoworkspace, e+1"
                "shift ctrl, left, movetoworkspace, e-1"
                "alt, q, killactive"
                "alt, return, exec, uwsm app -- \$terminal"
                "alt, escape, exec, uwsm app -- nwg-bar"
                "alt, space, exec, uwsm app -- \$terminal -e \$(tofi-run)"
                "shift alt, space, exec, uwsm app -- \$(tofi-drun)"
                "alt, d, exec, uwsm app -- \$terminal -e yazi"
                "shift alt, return, layoutmsg, swapwithmaster master"
                "shift alt, p, workspace, e-1"
                "shift alt, n, workspace, e+1"
              ];
            };
          };

          programs.hyprlock.enable = lib.mkIf (!pkgs.stdenv.isDarwin) (lib.mkDefault true);

          programs.tofi = lib.mkIf (!pkgs.stdenv.isDarwin) {
            enable = lib.mkDefault true;
            settings = {
              width = "%50";
              height = "40%";
              border-width = 2;
              outline-width = 0;
              padding-left = "2%";
              padding-top = "2%";
              result-spacing = 25;
              num-results = 10;
              prompt-text = " run: ";
              fuzzy-match = true;
              hide-cursor = true;
              history = true;
            };
          };

          programs.waybar.enable = lib.mkIf (!pkgs.stdenv.isDarwin) (lib.mkDefault true);
          programs.waybar.systemd.enable = lib.mkIf (!pkgs.stdenv.isDarwin) (lib.mkDefault true);

          services.cliphist.enable = lib.mkIf (!pkgs.stdenv.isDarwin) (lib.mkDefault true);

          services.hypridle = lib.mkIf (!pkgs.stdenv.isDarwin) {
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
                  timeout = 150;
                  on-timeout = "brightnessctl -s set 10";
                  on-resume = "brightnessctl -r";
                }
                {
                  timeout = 150;
                  on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
                  on-resume = "brightnessctl -sd rgb:kbd_backlight";
                }
                {
                  timeout = 300;
                  on-timeout = "loginctl lock-session";
                }
                {
                  timeout = 300;
                  on-timeout = "hyprctl dispatch dpms off";
                  on-resume = "hyprctl dispatch dpms on";
                }
                {
                  timeout = 1800;
                  on-timeout = "systemctl suspend";
                }
              ];
            };
          };

          home = lib.mkIf (!pkgs.stdenv.isDarwin) {
            sessionVariables.NIXOS_OZONE_WL = "1";
            packages = with pkgs; [
              hyprpicker
              hyprsunset
              nwg-bar
              awww
              wl-clipboard-rs
            ];
          };

          services.mako.enable = lib.mkIf (!pkgs.stdenv.isDarwin) (lib.mkDefault true);
        }
        # firefox configuration
        (lib.mkIf (config.wayland.windowManager.hyprland.enable or false) {
          programs.firefox.enable = lib.mkDefault true;
          programs.firefox.configPath = lib.mkDefault ".mozilla/firefox";

          home.packages = with pkgs; [
            firefox
          ];

          programs.firefox = {
            profiles.mark = {
              id = 0;
              name = "Mark Feltner";
              settings =
                let
                  newTab = {
                    "browser.newtabpage.activity-stream.feeds.topsites" = true;
                    "browser.newtabpage.activity-stream.feeds.topstories" = false;
                    "browser.newtabpage.activity-stream.feeds.section.highlights" = true;
                    "browser.newtabpage.activity-stream.feeds.highlights.includePocket" = false;
                    "browser.newtabpage.activity-stream.section.highights.includePocket" = false;
                    "browser.newtabpage.activity-stream.showSearch" = false;
                    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
                    "browser.newtabpage.activity-stream.showSponsored" = false;
                  };

                  searchBar = {
                    "browser.urlbar.suggest.quicksuggest.sponsored" = false;
                    "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
                  };

                  telemetry = {
                    "browser.newtabpage.activity-stream.telemetry" = false;
                    "browser.newtabpage.activity-stream.feeds.telemetry" = false;
                    "browser.ping-centre.telemetry" = false;
                    "toolkit.telemetry.reportingpolicy.firstRun" = false;
                    "toolkit.telemetry.unified" = false;
                    "toolkit.telemetry.archive.enabled" = false;
                    "toolkit.telemetry.updatePing.enabled" = false;
                    "toolkit.telemetry.shutdownPingSender.enabled" = false;
                    "toolkit.telemetry.newProfilePing.enabled" = false;
                    "toolkit.telemetry.bhrPing.enabled" = false;
                    "toolkit.telemetry.firstShutdownPing.enabled" = false;
                    "datareporting.healthreport.uploadEnabled" = false;
                    "datareporting.policy.dataSubmissionEnabled" = false;
                    "app.shield.optoutstudies.enable" = false;
                  };

                  https = {
                    "dom.security.https_only_mode" = true;
                    "dom.security.https_only_mode_ever_enabled" = true;
                  };

                  graphics = {
                    "media.ffmpeg.vaapi.enabled" = true;
                    "media.rdd-ffmpeg.enabled" = true;
                    "media.navigator.mediadataencoder_vpx_enabled" = true;
                  };

                  general_settings = {
                    "widget.use-xdg-desktop-portal.file-picker" = 2;
                    "widget.use-xdg-desktop-portal.mime-handler" = 2;
                    "browser.aboutConfig.showWarning" = false;
                    "browser.shell.checkDefaultBrowser" = false;
                    "browser.toolbars.bookmarks.visibility" = "newtab";
                    "browser.urlbar.showSearchSuggestionsFirst" = false;
                    "extensions.htmlaboutaddons.inline-options.enabled" = false;
                    "extensions.htmlaboutaddons.recommendations.enabled" = false;
                    "extensions.pocket.enabled" = false;
                    "browser.fullscreen.autohide" = false;
                  };

                  passwords = {
                    "signon.autofillForms" = false;
                    "signon.firefoxRelay.feature" = false;
                    "signon.generation.enabled" = false;
                    "signon.management.page.breach-alerts.enabled" = false;
                    "signon.rememberSignons" = false;
                  };

                  downloads = {
                    "browser.download.useDownloadDir" = false;
                  };

                  domPrivacy =
                    (import ./firefox-battery.nix { inherit config lib; })
                    .config.den.aspects.features.provides.gui.homeManager.programs.firefox.profiles.mark.settings.domPrivacy;
                in
                general_settings
                // https
                // newTab
                // searchBar
                // domPrivacy
                // telemetry
                // graphics
                // passwords
                // downloads;
              userChrome = ''
                /* hides the native tabs */
                #TabsToolbar, #sidebar-header {
                  visibility: none !important;
                }
              '';
              userContent = "";
            };
          };

          stylix.targets.firefox.profileNames = [ "mark" ];
        })
      ];
  };
}
