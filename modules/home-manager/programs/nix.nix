{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.programs.nix;

  extraPackages = with pkgs; [
    nix-health
    nix-tree
  ];
in
{
  options.feltnerm.programs.nix = {
    enable = lib.mkOption {
      description = "Enable the install of extra nix tools";
      default = false;
    };
  };

  config = {
    home.packages = if cfg.enable then extraPackages else [ ];
  };
}
