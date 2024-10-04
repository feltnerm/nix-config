_: {
  networking = {
    hostName = "monke";
    networkmanager.enable = true;
    firewall = {
      enable = false;
    };

    # only have WiFi, for now
    useDHCP = false;
    interfaces.wlp2s0.useDHCP = true;
    interfaces.enp3s0.useDHCP = false;
  };
}
