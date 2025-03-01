{ pkgs, ... }:
{
  system.stateVersion = 5;

  services = {
    yabai = {
      enable = true;
      config = {
        focus_follows_mouse = "off";
        mouse_follows_focus = "on";
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
    skhd = {
      enable = true;
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

  homebrew = {
    enable = true;
    casks = [
      # e-book manager
      "calibre"

      # Visual size
      "disk-inventory-x"

      # Dreams
      "electric-sheep"

      # Gdrive
      "google-drive"

      # 🦊
      "firefox"

      # block stuff
      "minecraft"

      # screen recorder and broadcaster
      "obs"

      # For Java
      "intellij-idea-ce"

      # VPN
      #"private-internet-access"

      # it's meh, but good visual editor
      "visual-studio-code"

      # VM mgmt
      "virtualbox"

      # media player
      "vlc"
    ];
  };

  # allow nix to manage fonts
  # FIXME fonts = lib.mkIf cfg.gui.fonts.enable {
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
}
