{lib, ...}: {
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
}
