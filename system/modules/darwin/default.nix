{
  config,
  inputs,
  lib,
  pkgs,
  username,
  ...
}: let
  cfg = config.feltnerm.darwin;
in {
  options.feltnerm.darwin = {
    enable = lib.mkEnableOption "darwin";
    fonts = {enable = lib.mkEnableOption "fonts";};
    homebrew = {enable = lib.mkEnableOption "homebrew";};
    security = {enable = lib.mkEnableOption "security";};
    users = {enable = lib.mkEnableOption "security";};
  };

  config = lib.mkIf cfg.enable {
    services.nix-daemon.enable = true;
    system.configurationRevision = inputs.rev or inputs.dirtyRev or null;

    users = lib.mkIf cfg.users.enable {
      users = {
        ${username} = {
          inherit (cfg) shell;

          uid = 1000;
          name = username;
          description = "${username}";
          createHome = true;
          home = "/Users/${username}";
        };
      };
    };

    nix.settings.trusted-users = lib.mkIf cfg.users.enable [username];

    fonts = lib.mkIf cfg.fonts.enable {
      packages = with pkgs; [
        # sans fonts
        comic-neue
        source-sans

        (nerdfonts.override {
          fonts = [
            "Hack"
            "IBMPlexMono"
            "Iosevka"
            "JetBrainsMono"
          ];
        })
      ];
    };

    security = lib.mkIf cfg.security.enable {
      pam.enableSudoTouchIdAuth = true;
    };

    system.defaults = {
      # GlobalPreferences.com.apple = {
      #   # disable mouse acceleration
      #   mouse.scaling = -1;

      #   # sound.beep.sound = "";
      # };

      # enable firewall
      # alf.globalstate = 1;

      # drop pings
      # alf.stealthenabled = 1;

      # allow signed apps to use the network by default
      # alf.allowdownloadsignedenabled = 1;
      # alf.allowsignedenabled = 1;

      dock = {
        appswitcher-all-displays = true;
        autohide = true;
        mru-spaces = false;
        showhidden = true;

        dashboard-in-overlay = false;
      };

      finder = {
        # show file extensions in Finder
        AppleShowAllExtensions = true;

        # show hidden files in Finder
        AppleShowAllFiles = true;

        # disable warning when changing file extension
        FXEnableExtensionChangeWarning = false;

        # list view
        # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View The default is icnv.
        FXPreferredViewStyle = "Nlsv";

        # show full POSIX path
        _FXShowPosixPathInTitle = true;

        QuitMenuItem = true;
      };

      loginwindow = {
        DisableConsoleAccess = true;
        GuestEnabled = false;
      };

      # FIXME
      # keyboard = {
      #   remapCapsLockToEscape = true;
      # };

      NSGlobalDomain = {
        # 24-hour clock
        AppleICUForce24HourTime = true;

        # dark mode
        AppleInterfaceStyle = "Dark";

        # FIXME defined in finder
        # show file extensions in Finder
        # AppleShowAllExtensions = true;

        # FIXME defined in finder
        # show hidden files in Finder
        # AppleShowAllFiles = true;

        # always show scroll bars
        AppleShowScrollBars = "Always";

        # key repeat
        # TODO find actual values
        # InitialKeyRepeat = 100;
        # KeyRepeat = 100;

        # stop messing with my text, Apple
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;

        # 1 (small), 2 (medium), 3 (large)
        NSTableViewDefaultSizeMode = 3;

        # use F1, F2, etc. as standard function keys
        # com.apple.keyboard.fnState = null;

        # FIXME
        # enable tap-to-click
        # com.apple.mouse.tapBehavior = 1;
        # FIXME
        # no beep
        # com.apple.sound.beep.feedback = 0;
      };

      # ActivityMonitor = {};
      # AppleFontSmoothing = null;
      # CustomSystemPreferences = {};
      # CustomUserPreferences = {};
    };

    homebrew = lib.mkIf cfg.homebrew.enable {
      enable = true;
      onActivation = {
        # enable homebrew auto-update during nix-darwin activation
        autoUpdate = false;
        cleanup = "none"; # uninstall?
        # enable homebrew to upgrade formulae during nix-darwin activation
        upgrade = true;
      };
      global = {
        # only update after nix-darwin activation, after _we_ run `brew update`
        autoUpdate = false;
      };

      taps = [
        "homebrew/bundle"
        "homebrew/cask"
        "homebrew/cask-fonts"
        "homebrew/cask-versions"
        "homebrew/core"
        "homebrew/services"
      ];

      brews = [
      ];

      casks = [
        # fonts
        "font-hack"
        "font-iosevka"
      ];
      # masApps = [];
    };
  };
}
