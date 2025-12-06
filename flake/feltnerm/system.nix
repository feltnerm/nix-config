/**
  Shared settings between Nix "systems" (i.e., non-home-manager systems like nix-darwin or a NixOS system).
  Contains options that are available for both.
*/
{
  config,
  lib,
  pkgs,
  ...
}:
{
  # shared locale settings
  time.timeZone = lib.mkDefault "America/Chicago";

  # shared documentations settings
  documentation = lib.mkIf config.documentation.enable {
    man.enable = true;
    info.enable = true;
  };

  # shared nix settings
  nix = {
    optimise.automatic = lib.mkDefault true;
    gc.automatic = lib.mkDefault true;
    settings = {
      # enable nix flake support
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Use shared binary caches
      extra-substituters = [ "https://feltnerm.cachix.org" ];
      extra-trusted-public-keys = [
        "feltnerm.cachix.org-1:ZZ9S0xOGfpYmi86JwCKyTWqHbTAzhWe4Qu/a/uHZBIQ="
      ];

    };
  };

  # shared nixpkgs settings
  nixpkgs.config = {
    allowUnfree = lib.mkDefault true;
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
  };

  # shared environment settings
  environment = {
    shells = [
      pkgs.bash
      pkgs.zsh
    ];

    systemPackages = with pkgs; [
      bash
      zsh
      vim
      git
      man
    ];
  };

  programs = {
    zsh.enable = lib.mkDefault true;
  };
}
