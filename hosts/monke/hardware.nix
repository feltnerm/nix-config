{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-pc-ssd
  ];

  # intel microcode
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
