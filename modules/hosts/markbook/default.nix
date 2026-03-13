{ den, ... }:
{
  den.aspects.markbook = {
    nixos.imports = [
      ./host.nix
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "25.11";
      }
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        nix.settings.trusted-users = [ "mark" ];
      }
    ];
    includes = [
      (den.aspects.features._.theme "catppuccin-latte")
      den.aspects.features._.gui
      den.aspects.features._.kanata
      den.aspects.features._.ssh-enable
      den.aspects.features._.nopasswd-wheel
      den.aspects.features._.networkmanager
      den.aspects.features._.firewall-off
      den.aspects.features._.audio
      den.aspects.features._.smart-card
      den.aspects.features._.intel-baseline
      den.aspects.features._.mark-user-hashed
      den.aspects.features._.mark-groups-full
      den.aspects.features._.nixvim-default
    ];
  };
}
