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

    # system.copySystemConfiguration = false;
    # system.stateVersion = 22;
  };
}
