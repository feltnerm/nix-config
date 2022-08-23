{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.gpg;

  # TODO add switch for GUI pinentry
  pinentry = {
    package = pkgs.pinentry-curses;
    name = "curses";
  };
in {
  options.feltnerm.programs.gpg = {
    enable = lib.mkOption {
      description = "Enable GPG";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pinentry.package];

    programs.gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
      enableScDaemon = false;
      pinentryFlavor = pinentry.name;
    };

    programs = {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      bash.profileExtra = "gpgconf --launch gpg-agent";
      fish.loginShellInit = "gpgconf --launch gpg-agent";
      zsh.loginExtra = "gpgconf --launch gpg-agent";
    };
  };
}
