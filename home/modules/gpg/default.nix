{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.gpg;
in {
  options.feltnerm.gpg = {
    enable = lib.mkEnableOption "gpg";

    pubKey = lib.mkOption {
      description = "GPG pub key";
      type = lib.types.str;
    };

    pinentryPackage = lib.mkPackageOption pkgs ["pinentry-curses"] {};
  };

  config = lib.mkIf cfg.enable {
    home.packages = [cfg.pinentryPackage];

    programs.gpg = {
      enable = true;
      #homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      # FIXME
      enable = lib.mkDefault true;
      enableSshSupport = true;
      enableExtraSocket = true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      inherit (cfg) pinentryPackage;
      sshKeys = [cfg.pubKey];
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
