{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.darwin;
in {
  imports = [];

  options.feltnerm.darwin = {
  };

  config = {
    # allow nix to manage fonts
    fonts.fontDir.enable = config.feltnerm.system.config.fonts.enable;
  };
}
