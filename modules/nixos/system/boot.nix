{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.system.boot;
in {
  options.feltnerm.system.boot = {
    cleanTmpDir = lib.mkOption {
      description = "Enabling wiping /tmp on reboot.";
      default = true;
    };
  };

  config = {
    boot.cleanTmpDir = cfg.cleanTmpDir;
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelParams = [];
    # boot.blacklistedKernelModules = [];
  };
}
