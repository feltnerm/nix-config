{
  inputs,
  ...
}:
{
  # Markbook (MacBook Pro 13" Late 2013) main system config
  # Notes:
  # - Uses simple ext4 filesystem (see hardware.nix for disk setup)
  # - Laptop power management via TLP and thermald
  # - GUI via Hyprland + greetd; HiDPI scaling can be tuned in home-manager
  # - Kanata keyboard mapping included for external Keychron K2

  imports = [
    # MacBook Pro 11,1 specific hardware profile (falls back to common if unavailable)
    inputs.hardware.nixosModules.apple-macbook-pro-11-1
    ./hardware.nix
  ];

  config = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "25.11";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Hostname
    networking.hostName = "markbook";

    # Trust local user for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    security.sudo.wheelNeedsPassword = false;

    # Networking basics
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # User shell is set in user/mark.nix

    # Base services
    services.openssh.enable = true;
    services.pipewire.enable = true;

    # GUI via module
    feltnerm.gui.enable = true;

    # Laptop power management via module
    feltnerm.laptop.enable = true;

    # Bluetooth via module
    feltnerm.bluetooth.enable = true;

    # Kanata via module
    feltnerm.kanata.enable = true;

    # Notes for future fine-tuning:
    # - Hyprland HiDPI scaling: set monitor scale in home-manager (e.g., 2.0 or 1.5)
    # - Function keys behavior: adjust hid_apple.fnmode via kernelParams
    # - Add brightnessctl if preferred over light
    # - Consider powertop for additional tuning (package only)
  };
}
