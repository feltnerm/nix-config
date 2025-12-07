{
  pkgs,
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

    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";

    nix.settings.trusted-users = [ "mark" ];

    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    users.users.mark.shell = pkgs.zsh;

    services.openssh.enable = true;

    # Allow cloud-init to inject SSH keys/users on first boot
    services.cloud-init.enable = true;

    # GUI setup: greetd + Hyprland
    services.greetd.enable = true;
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };

    environment.systemPackages = with pkgs; [
      kitty
      firefox
    ];

    services.qemuGuest.enable = true;
  };
}
