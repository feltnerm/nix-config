{ lib, config, username, ...}: let
  cfg = config.module.programs.nh;
in {
  options.feltnerm.programs.nh.enable = lib.mkEnableOption "nix-helper";

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      flake = "/home/${username}/code/nixos-configuration";

      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
    };
  };
}
