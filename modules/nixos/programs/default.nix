{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.programs;
in {
  config = {
    programs.zsh.enable = true;
  };
}
