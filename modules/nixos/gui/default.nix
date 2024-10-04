{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.feltnerm.gui;
in
{
  imports = [
    ./fonts.nix
  ];

  options.feltnerm.gui = {
    audio = {
      enable = lib.mkOption {
        description = "Enable audio";
        default = false;
      };
    };

    greet = {
      enable = lib.mkOption {
        description = "Enable login prompt";
        default = false;
      };

      defaultUser = lib.mkOption {
        description = "Default user to login as";
      };
    };

    hyprland = {
      enable = lib.mkOption {
        description = "Enable hyprland";
        default = false;
      };
    };
  };

  config = lib.mkMerge [
    {
      # dbus.enable = true;
      # qt.platformTheme = "qt5ct";
      environment.systemPackages = with pkgs; [
        xdg-utils
      ];
    }
    (lib.mkIf cfg.audio.enable {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    })
    (lib.mkIf cfg.hyprland.enable {
      programs.hyprland.enable = true;

      security.pam.services.swaylock = { };
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;

      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };

      services = {
        xserver.enable = false;
        greetd = lib.mkIf cfg.greet.enable {
          enable = true;
          restart = true;
          settings = {
            default_session = lib.mkIf (builtins.isString cfg.greet.defaultUser) {
              user = cfg.greet.defaultUser;
              # command = "$HOME/.wayland-session";
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/hyprland";
            };
          };
        };
      };
    })
  ];

  #services.xserver.displayManager.gdm.enable = cfg.gui.enable;
  #services.xserver.displayManager.plasma5.enable = cfg.gui.enable;

  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  extraPackages = with pkgs; [
  #    # nixos.wiki/wiki/Sway

  #    foot

  #    sway
  #    dbus-sway-environment
  #    configure-gtk
  #    wayland
  #    glib # gettings
  #    dracula-theme # gtk theme
  #    gnome3.adwaita-icon-theme # default gnome cursors

  #    # sway utils
  #    waybar
  #    swaylock
  #    swayidle

  #    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin/stdout
  #    wf-recorder

  #    # terminal
  #    alacritty # terminal

  #    # notificiations
  #    mako

  #    # screenshots
  #    grim
  #    slurp

  #    # launchers
  #    #dmenu
  #    wofi
  #  ];
  #};

  # FIXME
  #programs.qt5ct.enable = true;
}
