{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.system.nix;
in {
  options.feltnerm.system.nix = {
    enableFlake = lib.mkEnableOption "Enable nix flake support";

    allowBroken = lib.mkOption {
      description = "Allow broken nix pkgs.";
      type = lib.types.bool;
      default = false;
    };

    allowUnfree = lib.mkOption {
      description = "Break Stallman's heart.";
      type = lib.types.bool;
      default = true;
    };

    allowedUsers = lib.mkOption {
      description = "Users to give access to nix to.";
      default = [];
    };
  };

  config = {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 4d";
      };
      # package = pkgs.nixUnstable;
      extraOptions = lib.mkIf cfg.enableFlake ''
        experimental-features = nix-command flakes
      '';
      settings = {
        auto-optimise-store = true;
        allowed-users = cfg.allowedUsers;
        # substituters = [
        #   "https://cache.nixos.org?priority=10"
        #   "https://fortuneteller2k.cachix.org"
        # ];

        # trusted-public-keys = [
        #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        #   "fortuneteller2k.cachix.org-1:kXXNkMV5yheEQwT0I4XYh1MaCSz+qg72k8XAi2PthJI="
        # ];
      };
    };

    nixpkgs.config = {
      inherit (cfg) allowBroken;
      inherit (cfg) allowUnfree;
    };
  };
}
