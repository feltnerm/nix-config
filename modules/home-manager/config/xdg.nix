{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.config.xdg;
in {
  options.feltnerm.config.xdg = {
    enable = lib.mkOption {
      description = "Enable XDG directory support";
      default = true;
    };
  };

  #config = {
  #  home.xdg = lib.mkIf cfg.enable {
  #    # home.xdg = {
  #    enable = true;
  #    userDirs = {
  #      enable = true;
  #      createDirectories = true;
  #    };
  #    # };
  #  };
  #};
}
