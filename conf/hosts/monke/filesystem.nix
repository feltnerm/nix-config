_: {
  # F I L E S Y S T E M
  fileSystems = {
    "/boot" = {
      label = "MONKEBOOT";
      fsType = "vfat";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/" = {
      label = "NIXROOT";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/home" = {
      label = "MONKEHOME";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/opt/os/arch" = {
      label = "ARCHROOT";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };

    "/opt/os/ubuntu" = {
      label = "UBUNTUROOT";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "discard"
      ];
    };
  };
}
