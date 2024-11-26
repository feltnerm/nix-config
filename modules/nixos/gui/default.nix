{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./fonts.nix
  ];

  config = lib.mkMerge [
    {
      # dbus.enable = true;
      # qt.platformTheme = "qt5ct";
      environment.systemPackages = with pkgs; [
        xdg-utils
      ];
    }
    (lib.mkIf config.services.pipewire.enable {
      services.pipewire = {
        alsa.enable = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
      };
    })
    (lib.mkIf config.programs.hyprland.enable {
      security.pam.services.swaylock = { };
      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;

      xdg.portal = {
        enable = lib.mkDefault true;
        wlr.enable = lib.mkDefault true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-wlr
        ];
      };

      services = {
        xserver.enable = lib.mkDefault false;
        greetd = lib.mkIf config.services.greetd.enable {
          restart = lib.mkDefault true;
          settings = {
            # FIXME
            # default_session = lib.mkIf (builtins.isString cfg.greet.defaultUser) {
            #   user = cfg.greet.defaultUser;
            # command = "$HOME/.wayland-session";
            # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/hyprland";
            # };
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
