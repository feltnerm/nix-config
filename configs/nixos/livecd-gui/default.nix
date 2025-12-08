{
  ...
}:
{
  imports = [
    # Live CD GUI variant; hardware-agnostic
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Networking
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # GUI via module
    feltnerm.gui.enable = true;
  };
}
