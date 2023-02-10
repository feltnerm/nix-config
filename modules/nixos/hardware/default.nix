{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.hardware;
in {
  imports = [
    ./cpu.nix
    ./ssd.nix
  ];

  options.feltnerm.hardware.display = {
    enableHighResolutionDisplay = lib.mkOption {
      description = "Whether to configure the system for a high-res display.";
      default = false;
    };
  };

  options.feltnerm.hardware.bluetooth = {
    enable = lib.mkOption {
      description = "Enable Bluetooth.";
      default = false;
    };
  };

  config = {
    hardware.enableRedistributableFirmware = lib.mkDefault true;
    hardware.video.hidpi.enable = cfg.display.enableHighResolutionDisplay;
    hardware.bluetooth.enable = cfg.bluetooth.enable;
  };
}
