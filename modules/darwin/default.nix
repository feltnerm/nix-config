{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.darwin;
in {
  imports = [];

  options.feltnerm.darwin.homebrew = {
    enable = lib.mkOption {
      description = "Enable nix managing homebrew.";
      default = true;
    };
  };

  config = {
    # allow nix to manage fonts
    fonts.fontDir.enable = config.feltnerm.config.fonts.enable;

    # garbage collect daily
    nix.gc.interval = {
      Hour = 24;
      Minute = 0;
    };

    # Give admins enhanced nix privs
    nix.settings.trusted-users = ["@admin"];

    # enable Touch ID sudo authentication
    security.pam.enableSudoTouchIdAuth = true;

    system.defaults = {
      # GlobalPreferences.com.apple = {
      #   # disable mouse acceleration
      #   mouse.scaling = -1;

      #   # sound.beep.sound = "";
      # };

      # enable firewall
      alf.globalstate = 1;

      # drop pings
      alf.stealthenabled = 1;

      # allow signed apps to use the network by default
      alf.allowdownloadsignedenabled = 1;
      alf.allowsignedenabled = 1;

      dock = {
        appswitcher-all-displays = true;
        autohide = true;

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
      masApps = [];
    };

    programs = {
      info.enable = true;
      man.enable = true;
      zsh.enable = true;
    };
  };
}
