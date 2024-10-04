{
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.hardware.cpu;
in
{
  options.feltnerm.hardware.cpu = {
    enableMicrocode = lib.mkEnableOption "Enable CPU microcode updates";
    vendor = lib.mkOption {
      description = "CPU vendor";
      type = lib.types.enum [
        "intel"
        "amd"
      ];
    };
  };

  config = lib.mkIf config.feltnerm.hardware.cpu.enableMicrocode {
    hardware.cpu.intel.updateMicrocode = cfg.vendor == "intel";
    hardware.cpu.amd.updateMicrocode = cfg.vendor == "amd";
  };
}
