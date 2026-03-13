_: {
  config.den.aspects.features.provides.bluetooth = {
    nixos = {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;
    };
  };
}
