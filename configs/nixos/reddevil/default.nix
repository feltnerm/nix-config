{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./hardware.nix
  ];

  config = {
    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Trust mark for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    # Allow wheel group sudo without password for dev convenience
    security.sudo.wheelNeedsPassword = false;

    # User shell is set in user/mark.nix

    # SSH server (left enabled; can be tuned later)
    services.openssh.enable = true;
    services.openssh.settings.PermitRootLogin = "no";
    services.openssh.settings.PasswordAuthentication = false;

    # Minimal base dev packages; majority comes from home-manager
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
