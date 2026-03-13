{ den, ... }:
{
  den.aspects.livecd = {
    nixos.imports = [
      ./host.nix
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "25.11";
      }
      {
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
      }
    ];
    includes = [
      (den.aspects.features._.theme "catppuccin-mocha")
      den.aspects.features._.live-iso
      den.aspects.features._.ssh-hardened
      den.aspects.features._.networkmanager
      den.aspects.features._.firewall-ssh-only
      den.aspects.features._.mark-user-hashed
      den.aspects.features._.home-cli-minimal
      den.aspects.features._.nixvim-default
    ];
  };
}
