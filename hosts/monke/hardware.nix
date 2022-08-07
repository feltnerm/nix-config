{
  config,
  pkgs,
  lib,
  ...
}: {
  # intel microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
  hardware.bluetooth.enable = true;
}
