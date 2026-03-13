_: {
  config.den.aspects.features.provides.networkmanager = {
    nixos.networking.networkmanager.enable = true;
  };

  config.den.aspects.features.provides.firewall-off = {
    nixos.networking.firewall.enable = false;
  };

  config.den.aspects.features.provides.firewall-ssh-only = {
    nixos.networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}
