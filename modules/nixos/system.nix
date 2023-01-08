{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm;
in {
  options.feltnerm.boot = {
    cleanTmpDir = lib.mkOption {
      description = "Enabling wiping /tmp on reboot.";
      default = true;
    };
  };

  options.feltnerm.locale = {
    locale = lib.mkOption {
      description = "Locale for the system.";
      default = "en_US.UTF-8";
    };
  };

  config = {
    i18n.defaultLocale = cfg.locale.locale;

    nix.gc.dates = "daily";

    console = {
      # TODO
      #font = "Lat2-Terminus16";
      # keyMap = cfg.locale.keymap;
      useXkbConfig = true; # use xkbOptions in tty.
    };

    system.copySystemConfiguration = false;
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      allowReboot = false;
    };

    systemd.enableEmergencyMode = false;
    # TODO wat
    # services.journald.extraConfig = ''
    #   SystemMaxUse=100M
    #   MaxFileSec=7day
    # '';

    environment = {
      sessionVariables = {
        EDITOR = "vim";
        # TODO man, less, etc with colors
      };
    };

    boot.cleanTmpDir = cfg.boot.cleanTmpDir;
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelParams = [];
    # boot.blacklistedKernelModules = [];
  };
}
