_: {
  config = {
    feltnerm = {
      config.fonts.enable = true;
    };

    homebrew.enable = true;
    homebrew.casks = [
      # terminal
      "alacritty"

      # tiling window manager
      "amethyst"

      # stop from sleeping
      "caffeine"

      # Visual size
      "disk-inventory-x"

      # hide status bar icons
      "dozer"

      # Dreams
      "electric-sheep"

      # 🦊
      "firefox"

      # gimp
      "gimp"

      # Gdrive
      "google-drive"

      # aws java
      "corretto"
      "corretto8"

      # http request editor
      "insomnia"

      # For Java
      "intellij-idea"

      # eclipse memory analyzer
      "mat"

      # sql gui
      # "sequel-ace"

      "visualvm"

      # it's meh, but good visual editor
      "visual-studio-code"

      # screen recorder and broadcaster
      "obs"

      # Meeeeetings
      "zoom"
    ];
  };
}
