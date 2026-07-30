_: {
  config.den.aspects.features.provides.intel-baseline = {
    nixos = {
      hardware.enableRedistributableFirmware = true;
      hardware.cpu.intel.updateMicrocode = true;
      services.fstrim.enable = true;
    };
  };
}
