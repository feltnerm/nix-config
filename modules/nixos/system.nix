{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm;
in {
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
      sessionVariables = {};
    };

    boot.tmp.cleanOnBoot = lib.mkDefault true;
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelParams = [];
    # boot.blacklistedKernelModules = [];
  };
}
