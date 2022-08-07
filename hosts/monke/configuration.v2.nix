# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./boot.nix
    ./filesytem.nix
    ./hardware.nix
    ./networking.nix

    # include home-manager
    <home-manager/nixos>

    ../../src/common
    ../../src/desktop
  ];

  # TRIM for SSDs
  # x
  boot.kernel.sysctl = {"vm.swappiness" = lib.mkDefault 1;};
  services.fstrim.enable = lib.mkDefault true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Chicago";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  users = {
    mutableUsers = false;
    groups = {nixos-users = {};};
    users = {
      root = {
        # disable root login via password
        hashedPassword = "!";
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  # virtualisation.docker.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
