{
  config,
  lib,
  ...
}:
# Configure an OpenSSH server for the system
# TODO add ez configuration options to add users/groups of users like for a common network
# - list of users -> lookup keys
let
  cfg = config.feltnerm.services.openssh;
in {
  options.feltnerm.services.openssh = {
    enable = lib.mkEnableOption "openssh server";
    enableAtBoot = lib.mkEnableOption "openssh server at boot";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.openssh = {
        inherit (cfg) enable;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = true;
        };
      };
    })
    (lib.mkIf (cfg.enable && cfg.enableAtBoot) {
      boot.initrd.network.ssh.enable = cfg.enableAtBoot;
    })
  ];
}
