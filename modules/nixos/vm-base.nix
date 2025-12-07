{ lib, pkgs, ... }:
{
  config = {
    # Prefer simple DHCP networking for VMs
    networking = {
      networkmanager.enable = lib.mkForce false;
      useDHCP = lib.mkDefault true;
      firewall.enable = lib.mkDefault true;
      firewall.allowedTCPPorts = lib.mkDefault [ 22 ];
    };

    # SSH server with sane defaults
    services.openssh = {
      enable = lib.mkDefault true;
      settings = {
        PermitRootLogin = lib.mkDefault "no";
        PasswordAuthentication = lib.mkForce false;
      };
    };

    # Enable cloud-init to inject users/keys on first boot
    services.cloud-init.enable = lib.mkDefault true;

    # QEMU guest utilities
    services.qemuGuest.enable = lib.mkDefault true;

    # Trim build size/time for VMs
    documentation.enable = lib.mkDefault false;

    # Avoid GC and store optimize timers in VMs
    nix = {
      gc.automatic = lib.mkForce false;
      optimise.automatic = lib.mkForce false;
    };

    # Useful base packages; very minimal
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
