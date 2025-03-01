{
  config,
  lib,
  ...
}:
{

  nix = lib.mkIf config.nix.enable {
    gc = {
      automatic = lib.mkDefault true;
      interval = {
        Hour = lib.mkDefault 4;
        Minute = lib.mkDefault 0;
        Weekday = lib.mkDefault 7;
      };
    };

    settings = {
      # Give admins enhanced nix privs
      trusted-users = [ "@admin" ];
      auto-optimise-store = lib.mkDefault false;
    };
  };

  # enable Touch ID sudo authentication
  security.pam.services.sudo_local.touchIdAuth = lib.mkDefault true;

  system.keyboard = {
    enableKeyMapping = lib.mkDefault true;
    remapCapsLockToEscape = lib.mkDefault true;
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
      appswitcher-all-displays = lib.mkDefault true;
      autohide = lib.mkDefault true;
      mru-spaces = lib.mkDefault false;
      showhidden = lib.mkDefault true;

      dashboard-in-overlay = lib.mkDefault false;
    };

    finder = {
      # show file extensions in Finder
      AppleShowAllExtensions = lib.mkDefault true;

      # show hidden files in Finder
      AppleShowAllFiles = lib.mkDefault true;

      # disable warning when changing file extension
      FXEnableExtensionChangeWarning = lib.mkDefault false;

      # list view
      # "icnv" = Icon view, "Nlsv" = List view, "clmv" = Column View, "Flwv" = Gallery View The default is icnv.
      FXPreferredViewStyle = lib.mkDefault "Nlsv";

      # show full POSIX path
      _FXShowPosixPathInTitle = lib.mkDefault true;

      QuitMenuItem = lib.mkDefault true;
    };

    loginwindow = {
      DisableConsoleAccess = lib.mkDefault true;
      GuestEnabled = lib.mkDefault false;
    };

    NSGlobalDomain = {
      # 24-hour clock
      AppleICUForce24HourTime = lib.mkDefault true;

      # dark mode
      AppleInterfaceStyle = lib.mkDefault "Dark";

      # FIXME defined in finder
      # show file extensions in Finder
      # AppleShowAllExtensions = true;

      # FIXME defined in finder
      # show hidden files in Finder
      # AppleShowAllFiles = true;

      # always show scroll bars
      AppleShowScrollBars = lib.mkDefault "Always";

      # key repeat
      # TODO find actual values
      # InitialKeyRepeat = 100;
      # KeyRepeat = 100;

      # stop messing with my text, Apple
      NSAutomaticCapitalizationEnabled = lib.mkDefault false;
      NSAutomaticDashSubstitutionEnabled = lib.mkDefault false;
      NSAutomaticSpellingCorrectionEnabled = lib.mkDefault false;

      # 1 (small), 2 (medium), 3 (large)
      NSTableViewDefaultSizeMode = lib.mkDefault 3;

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

  homebrew = lib.mkIf config.homebrew.enable {
    onActivation = {
      # enable homebrew auto-update during nix-darwin activation
      autoUpdate = lib.mkDefault false;
      cleanup = lib.mkDefault "none"; # uninstall?
      # enable homebrew to upgrade formulae during nix-darwin activation
      upgrade = lib.mkDefault true;
    };
    global = {
      # only update after nix-darwin activation, after _we_ run `brew update`
      autoUpdate = lib.mkDefault false;
    };

    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];

    brews = [
    ];

    casks = [
      # fonts
      #"font-hack"
      #"font-iosevka"
    ];
    # masApps = [];
  };
}
