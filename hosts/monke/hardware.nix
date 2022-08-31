{
  config,
  pkgs,
  lib,
  ...
}: {
  # intel microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
