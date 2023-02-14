{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.config;
in {
  options.feltnerm.config.code = {
    enableCodeDir = lib.mkOption {
      description = "Enable code directory";
      default = false;
    };

    codeDir = lib.mkOption {
      description = "Set the the directory";
      default = "$HOME/code";
    };
  };

  config = {
    home.sessionVariables = lib.mkIf cfg.code.enableCodeDir {
      CODE_HOME = cfg.code.codeDir;
    };

    xdg = {
      enable = lib.mkDefault true;
      userDirs = {
        enable = lib.mkDefault false;
        createDirectories = lib.mkDefault true;
      };
    };
  };
}
