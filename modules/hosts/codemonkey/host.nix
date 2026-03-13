{ inputs, pkgs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
  ];

  config = {
    # Boot loader (EFI via systemd-boot)
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false; # rely on BIOS boot order

    system.stateVersion = "25.05";

    # Trust local user for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    environment.systemPackages = [ pkgs.nvtopPackages.amd ];
  };
}
