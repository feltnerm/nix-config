{
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # Minimal NixOS installer base
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  config = {
    # Keep installer small/light; rely on host configs for packages
    documentation.enable = lib.mkDefault false;

    # Provide disko; user will invoke it manually if desired
    environment.systemPackages = with pkgs; [
      disko
      vim
      git
      tmux
      htop
      curl
      wget
    ];

    # No auto-run installer; provide commands only
    # Users can run:
    #  nix run github:nix-community/disko -- --mode zap_create_mount /etc/nixos/hardware.nix
    #  nixos-install --flake /etc/nixos#<host>

    # Networking: assume ethernet; NetworkManager available for optional wifi
    networking.useDHCP = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;

    # Bootable ISO settings
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;
    isoImage.squashfsCompression = "zstd -Xcompression-level 15";
  };
}
