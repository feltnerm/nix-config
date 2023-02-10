{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.config.code;
in {
  imports = [
    ./xdg.nix
  ];

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
    home.sessionVariables = lib.mkIf cfg.enableCodeDir {
      CODE_HOME = cfg.codeDir;
    };
  };
}
