{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.feltnerm.hardware;
in {
  options.feltnerm.hardware = {
    audio = {
      enable = lib.mkEnableOption "audio";
    };

    bluetooth = {
      enable = lib.mkEnableOption "bluetooth";
    };

    cpu = {
      enableMicrocode = lib.mkEnableOption "cpu microcode";
      vendor = lib.mkOption {
        description = "CPU vendor";
        type = lib.types.enum ["intel" "amd"];
      };
    };

    ssd = {
      enable = lib.mkEnableOption "ssd";
    };
  };

  config = lib.mkMerge [
    {
      hardware.enableRedistributableFirmware = lib.mkDefault true;
    }
    (lib.mkIf cfg.audio.enable {
      users.extraGroups.audio.members = [username];
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
    })
    (lib.mkIf cfg.bluetooth.enable {
      hardware.bluetooth.enable = true;
    })
    (lib.mkIf cfg.cpu.enableMicrocode {
      hardware.cpu.intel.updateMicrocode = cfg.vendor == "intel";
      hardware.cpu.amd.updateMicrocode = cfg.vendor == "amd";
    })
    (lib.mkIf cfg.ssd.enable {
      boot.kernel.sysctl = {"vm.swappiness" = lib.mkDefault 1;};
      services.fstrim.enable = true;
    })
  ];
}
