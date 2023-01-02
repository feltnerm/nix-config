{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.darwin;
in {
  imports = [];

  config = {
    # allow nix to manage fonts
    fonts.fontDir.enable = config.feltnerm.config.fonts.enable;
  };
}
