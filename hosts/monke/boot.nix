_: {
  # use the GRUB2 bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      editor = false;
    };
    grub = {
      enable = false;
      version = 2;
      device = "nodev";
      efiSupport = true;
      useOSProber = false;
      #memtest86.enable = true;
    };

    efi = {
      canTouchEfiVariables = true;
    };
  };

  boot.initrd.luks.devices = {
    cryptlvm = {
      device = "/dev/disk/by-uuid/d3aa3dac-8702-4b08-9f4b-c7f86fb685e3";
      fallbackToPassword = true;
      preLVM = true;
      allowDiscards = true;
    };
  };
}
