{ lib, ... }:
{
  config.den.aspects.features.provides.darwin-base.darwin.imports = [
    {
      system.defaults.controlcenter.BatteryShowPercentage = lib.mkDefault true;
    }
  ];
}
