{
  inputs,
  ...
}:
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
    nixpkgs.hostPlatform = "x86_64-linux";

    # Trust local user for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    security.sudo.wheelNeedsPassword = false;

    # Networking basics handled per host here
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # User shell is set in user/mark.nix

    # Base services
    services.openssh.enable = true;
    services.pipewire.enable = true;
    services.pcscd.enable = true;

    # GUI stack via module
    feltnerm.gui.enable = true;

    # Kanata via module
    feltnerm.kanata.enable = true;
  };
}
