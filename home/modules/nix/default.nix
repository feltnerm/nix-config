{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = cfg.feltnerm.nix;
in {
  options.feltnerm.nix = {
    enable = lib.mkEnableOption "nix extra tools";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nix-health
      nix-tree
    ];
  };
}
