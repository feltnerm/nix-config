{ config, lib, ... }:
let
  cfg = config.feltnerm.bluetooth;
in
{
  options.feltnerm.bluetooth = {
    enable = lib.mkEnableOption "bluetooth support";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = lib.mkDefault true;
    services.blueman.enable = true;
  };
}
