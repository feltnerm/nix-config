{
  lib,
  ...
}:
# Configure an OpenSSH server for the system
# TODO add ez configuration options to add users/groups of users like for a common network
# - list of users -> lookup keys
{
  config.den.aspects.features.provides.ssh-server = {
    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = lib.mkDefault "no";
          PasswordAuthentication = lib.mkDefault true;
        };
      };

      boot.initrd.network.ssh.enable = lib.mkDefault true;
    };
  };
}
