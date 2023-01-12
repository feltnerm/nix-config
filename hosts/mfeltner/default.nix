_: {
  # imports = [
  #   ./hardware-configuration.nix
  #   ./boot.nix
  #   ./filesystem.nix
  #   ./hardware.nix
  #   ./networking.nix
  # ];

  config = {
    feltnerm = {};

    homebrew.casks = [
      # tiling window manager
      "amethyst"

      # stop from sleeping
      "caffeine"

      # Visual size
      "disk-inventory-x"

      # Dreams
      "electric-sheep"

      # 🦊
      # TODO use home-manager
      "firefox"

      # terminal
      "alacritty"

      # stop from sleeping
      "caffeine"

      # aws java
      "corretto"
      "corretto8"
      # sql gui
      "sequel-ace"

      # http request editor
      "insomnia"

      # For Java
      "intellij-idea"

      # it's meh, but good visual editor
      "visual-studio-code"
    ];

    # system.copySystemConfiguration = false;
    # system.stateVersion = 22;
  };
}
