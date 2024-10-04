{
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.hardware.ssd;
in
{
  options.feltnerm.hardware.ssd = {
    enable = lib.mkEnableOption "Enable support for SSDs";
  };

  config = lib.mkIf cfg.enable {
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 1;
    };
    services.fstrim.enable = true;
  };
}
