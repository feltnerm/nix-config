_: {
  config = {
    feltnerm = {
      config.fonts.enable = true;
    };

    services = {
      # yabai.enable = true;
      # skhd.enable = true;
    };

    homebrew.enable = true;
    homebrew.casks = [
      # terminal
      "alacritty"

      # tiling window manager
      # TODO replace with yabai
      "amethyst"

      # stop from sleeping
      "caffeine"

      # e-book manager
      "calibre"

      # hide status bar icons
      "dozer"

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

      # remote fs gui
      "cyberduck"

      # http request editor
      "insomnia"

      # For Java
      "intellij-idea-ce"

      # sql gui
      "sequel-ace"

      # VPN
      "tunnelblick"
      "private-internet-access"

      # it's meh, but good visual editor
      "visual-studio-code"

      # VM mgmt
      "vagrant"
      "virtualbox"

      # media player
      "vlc"
    ];
  };
}
