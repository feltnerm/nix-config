{
  pkgs,
  ...
}:
{
  imports = [
    # Live CD should remain hardware-agnostic; no hardware.nix
    ../../../flake/feltnerm/system.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Networking suitable for a live environment
    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];

    # SSH for remote access if needed
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.settings.PasswordAuthentication = false;

    # Basic CLI tools
    environment.systemPackages = with pkgs; [
      vim
      git
      tmux
      htop
      curl
      wget
    ];
  };
}
