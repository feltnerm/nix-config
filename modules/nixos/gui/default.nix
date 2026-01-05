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
    enable = lib.mkEnableOption "GUI stack (Hyprland + greetd + terminal)";
  };

  config = lib.mkMerge [
    # When feltnerm.gui.enable = true, set common GUI stack defaults
    (lib.mkIf cfg.enable {
      services.greetd.enable = true;
      services.pipewire.enable = true;
      programs.hyprland.enable = true;
      programs.hyprlock.enable = true;
      security.pam.services.hyprlock = { };
      environment.systemPackages = lib.mkDefault (
        with pkgs;
        [
          xdg-utils
          kitty
        ]
      );
    })

    {
      # dbus.enable = true;
      # qt.platformTheme = "qt5ct";
      environment.systemPackages = with pkgs; [
        xdg-utils
      ];
    }
    # audio
    (lib.mkIf config.services.pipewire.enable {
      services.pipewire = {
        alsa.enable = lib.mkDefault true;
        pulse.enable = lib.mkDefault true;
      };
    })
    # hyprland
    (lib.mkIf config.programs.hyprland.enable {
      programs.hyprlock.enable = true;
      security.pam.services.hyprlock = { };
      services.hypridle.enable = true;

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;

      xdg.portal = {
        enable = lib.mkDefault true;
        wlr.enable = true;
        extraPortals = with pkgs; [
          # xdg-desktop-portal-gtk
          # xdg-desktop-portal-wlr
        ];
      };

      # uwsm
      programs.hyprland.withUWSM = lib.mkDefault true;
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
      services = {
        greetd = lib.mkIf config.services.greetd.enable {
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
      };
    })
  ];
}
