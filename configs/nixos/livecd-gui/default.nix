{
  pkgs,
  ...
}:
{
  imports = [
    # Live CD GUI variant; hardware-agnostic
    ../../../flake/feltnerm/system.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Networking
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # GUI setup: greetd + Hyprland
    services.greetd.enable = true;
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };

    environment.systemPackages = with pkgs; [
      kitty
      firefox
    ];
  };
}
