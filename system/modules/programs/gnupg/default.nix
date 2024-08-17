{
  lib,
  config,
  ...
}: let
  cfg = config.feltnerm.programs.gnupg;
in {
  options = {
    feltnerm.programs.gnupg.enable = lib.mkEnableOption "gpg";
  };

  config = lib.mkIf cfg.enable {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      # pinentryPackage = lib.mkForce pkgs.pinentry-qt;
    };
  };
}
