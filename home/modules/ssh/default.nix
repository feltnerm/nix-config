{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.ssh;
in {
  options.feltnerm.ssh = {
    enable = lib.mkEnableOption "ssh";
  };

  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
    };
  };
}
