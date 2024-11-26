{
  pkgs,
  config,
  lib,
  ...
}:
let
  # TODO add switch for GUI pinentry
  pinentry = {
    package = pkgs.pinentry-curses;
    name = "curses";
  };
in
{
  config = lib.mkIf config.programs.gpg.enable {
    home.packages = [ pinentry.package ];

    programs.gpg = {
      #homedir = "${config.xdg.dataHome}/gnupg";
    };

    services.gpg-agent = {
      # FIXME
      enable = lib.mkDefault true;
      enableSshSupport = lib.mkDefault true;
      enableExtraSocket = lib.mkDefault true;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      pinentryPackage = pinentry.package;
    };

    #programs.git.extraConfig.user.signgingKey = cfg.pubKey;

    programs = {
      # Start gpg-agent if it's not running or tunneled in
      # SSH does not start it automatically, so this is needed to avoid having to use a gpg command at startup
      # https://www.gnupg.org/faq/whats-new-in-2.1.html#autostart
      bash.profileExtra = lib.mkIf config.programs.bash.enable "gpgconf --launch gpg-agent";
      fish.loginShellInit = lib.mkIf config.programs.fish.enable "gpgconf --launch gpg-agent";
      zsh.loginExtra = lib.mkIf config.programs.zsh.enable "gpgconf --launch gpg-agent";
    };
  };
}
