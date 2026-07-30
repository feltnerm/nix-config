_: {
  den.aspects.ssh = {
    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = true;
        };
      };

      boot.initrd.network.ssh.enable = true;
    };
  };

  den.aspects.ssh.hardened = {
    nixos.services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
