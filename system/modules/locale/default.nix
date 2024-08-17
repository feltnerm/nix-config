{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.locale;
in {
  # locale
  options.feltnerm.locale = {
    enable = lib.mkEnableOption "locale";

    timezone = lib.mkOption {
      description = "System timezone";
      default = "America/Chicago";
    };

    keymap = lib.mkOption {
      description = "System keymap";
      default = "us";
    };

    locale = lib.mkOption {
      description = "Locale for the system.";
      default = "en_US.UTF-8";
    };
  };
  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timezone;
    services.chrony.enable = true;

    i18n = {
      defaultLocale = cfg.locale;
      extraLocaleSettings = {
        LC_ADDRESS = cfg.locale;
        LC_IDENTIFICATION = cfg.locale;
        LC_MEASUREMENT = cfg.locale;
        LC_MONETARY = cfg.locale;
        LC_NAME = cfg.locale;
        LC_NUMERIC = cfg.locale;
        LC_PAPER = cfg.locale;
        LC_TELEPHONE = cfg.locale;
        LC_TIME = cfg.locale;
      };
    };
  };
}
