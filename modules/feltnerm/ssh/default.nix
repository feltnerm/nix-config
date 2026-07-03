_: {
  config.den.aspects.features.provides.ssh-enable = {
    nixos.services.openssh.enable = true;
    nixos.services.openssh.settings.PermitRootLogin = "no";
    nixos.services.openssh.settings.PasswordAuthentication = true;
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
