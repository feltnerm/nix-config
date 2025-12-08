{ lib, pkgs, ... }:
{
  config = {
    # Max offline capability: include common tooling
    environment.systemPackages = with pkgs; [
      vim
      git
      tmux
      htop
      curl
      wget
      file
      pciutils
      usbutils
      lsof
      ncdu
      tree
      parted
      gptfdisk
      e2fsprogs
      btrfs-progs
      xfsprogs
      ntfs3g
      dosfstools
      zfs
    ];

    # Networking basics; assume ethernet
    networking.useDHCP = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;

    # Firmware for broad hardware support
    hardware.enableRedistributableFirmware = true;

    # Make ISO bootable on EFI/USB
    isoImage.makeEfiBootable = true;
    isoImage.makeUsbBootable = true;
    isoImage.squashfsCompression = "zstd -Xcompression-level 15";

    # Keep manuals off to reduce closure a bit
    documentation.enable = lib.mkDefault false;

    # Useful services
    services.openssh.enable = lib.mkDefault true;
    services.openssh.settings.PermitRootLogin = lib.mkDefault "no";
    services.openssh.settings.PasswordAuthentication = lib.mkDefault false;

    # Console quality of life
    console.enable = lib.mkDefault true;
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
    time.timeZone = lib.mkDefault "America/New_York";
  };
}
