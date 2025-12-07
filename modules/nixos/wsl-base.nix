{ lib, pkgs, ... }:
{
  config = {
    # Enable WSL integration
    wsl = {
      enable = true;
      defaultUser = "mark";
      startMenuLaunchers = false; # CLI only

      wslConf = {
        automount = {
          enabled = true;
          root = "/mnt";
          options = "metadata,uid=1000,gid=100";
        };

        interop = {
          enabled = true;
          # Avoid PATH pollution from Windows
          appendWindowsPath = false;
        };

        network = {
          generateHosts = true;
          generateResolvConf = true;
        };
      };
    };

    # No boot loader for WSL
    boot.loader.systemd-boot.enable = lib.mkForce false;
    boot.isContainer = true;

    # WSL handles networking
    networking = {
      dhcpcd.enable = false;
      networkmanager.enable = lib.mkForce false;
      useHostResolvConf = false;
    };

    # SSH server (optional, secure defaults)
    services.openssh = {
      enable = lib.mkDefault true;
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        PasswordAuthentication = lib.mkForce false;
      };
    };

    # Disable VM/cloud services not applicable to WSL
    services.qemuGuest.enable = lib.mkForce false;
    services.cloud-init.enable = lib.mkForce false;

    # Trim documentation for faster builds
    documentation.enable = lib.mkDefault false;

    # Dev-oriented Nix settings
    nix = {
      gc.automatic = lib.mkForce false;
      optimise.automatic = lib.mkForce false;
    };

    # Base packages; most dev tools come from home-manager
    environment.systemPackages = lib.mkDefault (
      with pkgs;
      [
        vim
        git
        tmux
        htop
        curl
        wget
      ]
    );
  };
}
