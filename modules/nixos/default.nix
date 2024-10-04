# NixOS settings
{
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm;
in
{
  imports = [
    ../common.nix
    ../system.nix
    ./gui
    ./hardware
    ./networking.nix
    ./programs
    ./security
    ./services
  ];

  config = {
    environment = {
      # environment variables
      sessionVariables = { };
    };

    nix = {
      gc = {
        # garbage collect every week
        dates = "weekly";
        options = "--delete-older-than 4d";
      };
    };

    documentation = lib.mkIf config.feltnerm.documentation.enable {
      man = {
        generateCaches = true;
      };
      dev.enable = true;
      nixos.enable = true;
    };

    i18n.defaultLocale = cfg.locale.locale;

    system = {
      copySystemConfiguration = false;

      # auto-upgrade the system weekly
      autoUpgrade = {
        enable = true;
        dates = "weekly";
        allowReboot = false;
      };
    };

    systemd.enableEmergencyMode = false;
    # TODO wat
    # services.journald.extraConfig = ''
    #   SystemMaxUse=100M
    #   MaxFileSec=7day
    # '';

    boot.tmp.cleanOnBoot = lib.mkDefault true;
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    # boot.kernelParams = [];
    # boot.blacklistedKernelModules = [];

    console = {
      # TODO set a console font (for widescreen can use `config.feltnerm.hardware.display`)
      # font = "Lat2-Terminus16";
      # keyMap = cfg.locale.keymap;
      # use xkbOptions in tty.
      useXkbConfig = true;
    };
  };
}
