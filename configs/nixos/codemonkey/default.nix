{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./hardware.nix
  ];

  config = {
    # Boot loader (EFI via systemd-boot)
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false; # rely on BIOS boot order

    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";

    # Trust local user for builds/switches
    nix.settings.trusted-users = [ "mark" ];

    # Networking basics handled per host here
    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    # User shell
    users.users.mark.shell = pkgs.zsh;

    # Base services
    services.openssh.enable = true;
    services.pipewire.enable = true;

    # GUI stack via module
    feltnerm.gui.enable = true;

    # Kanata via module
    feltnerm.kanata.enable = true;

    # Secrets: host and user-level
    feltnerm.secrets = {
      enable = true;
      hostSecrets = [ "opencode-api-token" ];
      userSecrets = { mark = [ "opencode-api-token" ]; };
    };
  };
}
