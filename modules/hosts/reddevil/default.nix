{ den, ... }:
{
  den.aspects.reddevil = {
    nixos.imports = [
      ./host.nix
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "25.11";
      }
      {
        nix.settings.trusted-users = [ "mark" ];
      }
    ];
    includes = [
      (den.aspects.features._.theme "catppuccin-macchiato")
      den.aspects.features._.wsl-base
      den.aspects.features._.wsl
      den.aspects.features._.ssh-hardened
      den.aspects.features._.nopasswd-wheel
      den.aspects.features._.home-wsl-vars
      den.aspects.features._.nixvim-default
    ];
  };
}
