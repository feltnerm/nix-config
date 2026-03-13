_: {
  config.den.aspects.features.provides.ssh-enable = {
    nixos.services.openssh.enable = true;
  };

  config.den.aspects.features.provides.ssh-hardened = {
    nixos.services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
