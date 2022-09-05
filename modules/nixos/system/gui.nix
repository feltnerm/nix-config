{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.feltnerm.system.gui;

  # nixos.wiki/wiki/Sway
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wrl
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
  };
in {
  options.feltnerm.system.gui = {
    enable = lib.mkOption {
      description = "Enable desktop GUI";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      greetd.gtkgreet
      greetd.tuigreet
    ];

    #services.xserver.displayManager.gdm.enable = cfg.gui.enable;
    #services.xserver.displayManager.plasma5.enable = cfg.gui.enable;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        # nixos.wiki/wiki/Sway

        sway
        dbus-sway-environment
        configure-gtk
        wayland
        glib # gettings
        dracula-theme # gtk theme
        gnome3.adwaita-icon-theme # default gnome cursors

        # sway utils
        swaylock
        swayidle

        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin/stdout
        wf-recorder

        # terminal
        alacritty # terminal

        # notificiations
        mako

        # screenshots
        grim
        slurp

        # launchers
        #dmenu
        wofi
      ];
    };

    services.greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          #user = "greeter";
          command = ''
            ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --remember \
            --remember-session \
            --time --issue --asterisks \
            --cmd '${pkgs.sway}/bin/sway'
          '';
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      sway
      zsh
    '';

    services.dbus.enable = true;
    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      gtkUsePortal = true;
    };

    programs.waybar.enable = true;
    programs.qt5ct.enable = true;

    # sound
    sound.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };
}
