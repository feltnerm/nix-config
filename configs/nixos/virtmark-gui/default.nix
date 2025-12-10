{
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../../modules/nixos/vm-base.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";

    nix.settings.trusted-users = [ "mark" ];

    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    services.openssh.enable = true;

    # Allow cloud-init to inject SSH keys/users on first boot
    services.cloud-init.enable = true;

    # GUI via module
    feltnerm.gui.enable = true;

    services.qemuGuest.enable = true;
  };
}
