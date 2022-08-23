{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.ssh;
in {
  options.feltnerm.programs.ssh = {
    enable = lib.mkOption {
      description = "Enable SSH";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
    };
  };
}
