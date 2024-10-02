{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.nix;
in {
  options.feltnerm.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      # package = pkgs.nixFlakes;
      settings = {
        auto-optimise-store = lib.mkDefault true;
        substituters = [];
        trusted-public-keys = [];
        experimental-features = ["nix-command" "flakes"];
      };

      gc = {
        automatic = true;
        options = "--delete-older-than 14d";
      };
    };
  };
}
