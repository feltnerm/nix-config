{
  config,
  lib,
  pkgs,
  ...
}:
# Configure an OpenSSH server for the system
# TODO add ez configuration options to add users/groups of users like for a common network
# - list of users -> lookup keys
let
  cfg = config.feltnerm.services.openssh;
in {
  options.feltnerm.services.openssh = {
    enable = lib.mkOption {
      description = "Enable OpenSSH server.";
      default = false;
    };

    enableAtBoot = lib.mkOption {
      description = "Enable OpenSSH server during initrd boot.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      inherit (cfg) enable;
      permitRootLogin = "no";
      passwordAuthentication = true;
    };

    boot.initrd.network.ssh.enable = cfg.enableAtBoot;
  };
}
