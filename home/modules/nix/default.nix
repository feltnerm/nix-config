{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.nix;
in {
  options.feltnerm.nix = {
    enableTools = lib.mkEnableOption "nix extra tools";
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        nix-health
        nix-output-monitor
        nix-tree
        nvd
      ];
      shellAliases = {
        # nix aliases
        n = "${pkgs.nix}/bin/nix";
        nd = "${pkgs.nix}/bin/nix develop -c $SHELL";
        ndc = "${pkgs.nix}/bin/nix develop -c";
        ns = "${pkgs.nix}/bin/nix shell";
        nsn = "${pkgs.nix}/bin/nix shell nixpkgs#";
        nb = "${pkgs.nix}/bin/nix build";
        nbn = "${pkgs.nix}/bin/nix build nixpkgs#";
        nf = "${pkgs.nix}/bin/nix flake";
      };
    };
  };
}
