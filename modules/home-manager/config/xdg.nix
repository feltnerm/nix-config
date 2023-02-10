{
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

  options.feltnerm.config.xdg = {
    enableUserDirs = lib.mkOption {
      description = "Enable XDG user-dirs.dir support";
      default = true;
    };
  };

  config = {
    xdg = {
      inherit (cfg) enable;
      userDirs = {
        enable = cfg.enableUserDirs;
        createDirectories = true;
      };
    };
  };
}
