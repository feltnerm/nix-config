{
  pkgs,
  inputs,
  ...
}: {
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

      # Visual size
      "disk-inventory-x"

      # Dreams
      "electric-sheep"

      # For Java
      "intellij-idea-ce"

      # block stuff
      "minecraft"

      # VPN
      "private-internet-access"

      # it's meh, but good visual editor
      "visual-studio-code"

      # VM mgmt
      "vagrant"
      "virtualbox"
    ];

    # system.copySystemConfiguration = false;
    # system.stateVersion = 22;
  };
}
