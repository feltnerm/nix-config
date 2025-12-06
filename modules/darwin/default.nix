{
  pkgs,
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
      autohide-delay = lib.mkDefault 0.100;
      dashboard-in-overlay = lib.mkDefault false;
      mru-spaces = lib.mkDefault false;
      show-recents = lib.mkDefault false;
      showhidden = lib.mkDefault true;
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

      # show folders first when sorting by name
      _FXSortFoldersFirst = lib.mkDefault true;

      # show path breadcrumbs
      ShowPathbar = lib.mkDefault true;

      # show disk space stats at the bottom of finder windows
      ShowStatusBar = lib.mkDefault true;

      QuitMenuItem = lib.mkDefault true;
    };

    menuExtraClock = {
      # 24-hour clock
      Show24Hour = lib.mkDefault true;
      ShowDate = lib.mkDefault 1;
    };

    screencapture = {
      # immediately open screenshots in preview
      target = lib.mkDefault "preview";
      type = lib.mkDefault "png";
    };

    loginwindow = {
      DisableConsoleAccess = lib.mkDefault true;
      GuestEnabled = lib.mkDefault false;
    };

    NSGlobalDomain = {
      AppleEnableMouseSwipeNavigateWithScrolls = lib.mkDefault true;

      # 24-hour clock
      AppleICUForce24HourTime = lib.mkDefault true;

      # dark mode
      AppleInterfaceStyle = lib.mkDefault "Dark";

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
      "com.apple.keyboard.fnState" = lib.mkDefault true;
      # enable tap-to-click
      "com.apple.mouse.tapBehavior" = lib.mkDefault 1;
      # no beep
      "com.apple.sound.beep.feedback" = lib.mkDefault 0;
      # disable "natural" scroll
      "com.apple.swipescrolldirection" = lib.mkDefault false;
    };

    WindowManager = {
      # disable apple tiling
      EnableTilingByEdgeDrag = lib.mkDefault false;
      EnableTilingOptionAccelerator = lib.mkDefault false;
      EnableTopTilingByEdgeDrag = lib.mkDefault false;

      # disable stage man
      GloballyEnabled = lib.mkDefault false;
      # click wallpaper to reveal desktop
      EnableStandardClickToShowDesktop = lib.mkDefault true;
    };

    controlcenter = {
      AirDrop = lib.mkDefault false;
      BatteryShowPercentage = lib.mkDefault true;
      Bluetooth = lib.mkDefault true;
      Display = lib.mkDefault false;
      FocusModes = lib.mkDefault false;
      NowPlaying = lib.mkDefault false;
      Sound = lib.mkDefault true;
    };

    # ActivityMonitor = {};
    # AppleFontSmoothing = null;
    # CustomSystemPreferences = {};
    # CustomUserPreferences = {};
  };

  # allow nix to manage fonts
  fonts = {
    packages = with pkgs; [
      # sans fonts
      comic-neue
      source-sans

      # monospace
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.blex-mono
    ];
  };

  nix-homebrew = lib.mkIf config.homebrew.enable {
    enable = true;
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

    taps = [ ];

    brews = [ ];

    casks = [
      # fonts
      #"font-hack"
      #"font-iosevka"
    ];
    # masApps = [];
  };

  services = {
    yabai = lib.mkIf config.services.yabai.enable {
      config = {
        focus_follows_mouse = "off";
        mouse_follows_focus = "off";
        mouse_modifier = "alt";
        mouse_action1 = "move";
        mouse_action2 = "resize";
        mouse_drop_action = "swap";

        layout = "bsp";
        split_ratio = "0.5";
        top_padding = 12;
        bottom_padding = 12;
        left_padding = 12;
        right_padding = 12;
        window_gap = 12;
        insert_window_space = "off";
        window_border = "on";
        window_border_radius = 8;
        window_border_width = 4;
        window_opacity = "off";
        window_placement = "second_child";
        window_topmost = "off";
      };
    };
    skhd = lib.mkIf config.services.skhd.enable {
      skhdConfig = ''
        # Focus
        alt - h : yabai -m window --focus west
        alt - j : yabai -m window --focus south
        alt - k : yabai -m window --focus north
        alt - l : yabai -m window --focus east

        # Swap
        shift + alt - h : yabai -m window --swap west
        shift + alt - j : yabai -m window --swap south
        shift + alt - k : yabai -m window --swap north
        shift + alt - l : yabai -m window --swap east

        # move window and split
        ctrl + alt - j : yabai -m window --warp south
        ctrl + alt - k : yabai -m window --warp north
        ctrl + alt - h : yabai -m window --warp west
        ctrl + alt - l : yabai -m window --warp east

        #change focus between external displays (left and right)
        alt - g: yabai -m display --focus east
        alt - s: yabai -m display --focus west

        # move window to display left and right
        shift + alt - g : yabai -m window --display east; yabai -m display --focus east;
        shift + alt - s : yabai -m window --display west; yabai -m display --focus west;

        # move window to prev and next space
        shift + alt - p : yabai -m window --space prev;
        shift + alt - n : yabai -m window --space next;

        # move window to space #
        shift + alt - 1 : yabai -m window --space 1;
        shift + alt - 2 : yabai -m window --space 2;
        shift + alt - 3 : yabai -m window --space 3;
        shift + alt - 4 : yabai -m window --space 4;
        shift + alt - 5 : yabai -m window --space 5;
        shift + alt - 6 : yabai -m window --space 6;
        shift + alt - 7 : yabai -m window --space 7;

        # rotate layout clockwise
        shift + alt - r : yabai -m space --rotate 270

        # flip along y-axis
        shift + alt - y : yabai -m space --mirror y-axis

        # flip along x-axis
        shift + alt - x : yabai -m space --mirror x-axis

        # toggle window float
        shift + alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

        # Resize master pane
        alt - left : yabai -m window --resize left:-20:0
        alt - right : yabai -m window --resize right:-20:0

        # Move window to master
        shift + alt - return : yabai -m window --warp master

        # Float/Unfloat window
        shift + alt - f : yabai -m window --toggle float

        # Toggle window fullscreen
        shift + alt - m : yabai -m window --toggle zoom-fullscreen

        # open terminal
        cmd - return : /Applications/iTerm.app/Contents/MacOS/iTerm2

        # Reload yabai and skhd
        ctrl + alt - r : yabai --restart && skhd --restart
      '';
    };
  };
}
