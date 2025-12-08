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

    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";

    nix.settings.trusted-users = [ "mark" ];

    networking.networkmanager.enable = true;
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];

    users.users.mark.shell = pkgs.zsh;

    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.settings.PasswordAuthentication = false;

    # Allow cloud-init to inject SSH keys/users on first boot
    services.cloud-init.enable = true;

    services.qemuGuest.enable = true;

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
