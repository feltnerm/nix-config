{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.nix;
in {
  options.feltnerm.nix = {
    enable = lib.mkEnableOption "nix";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
    };

    nix = {
      settings = {
        auto-optimise-store = lib.mkDefault true;
        subsituters = [];
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
