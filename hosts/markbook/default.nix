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
      "firefox"

      # block stuff
      "minecraft"

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

    # system.copySystemConfiguration = false;
    # system.stateVersion = 22;
  };
}
