_: {
  # F I L E S Y S T E M
  swapDevices = [];
  fileSystems = {
    "/boot" = {
      label = "MONKEBOOT";
      options = ["noatime" "nodiratime" "discard"];
      device = "/dev/disk/by-uuid/817B-6DC3";
      fsType = "vfat";
    };

    "/" = {
      label = "NIXROOT";
      options = ["noatime" "nodiratime" "discard"];
      device = "/dev/disk/by-uuid/2415ce1f-45cf-4141-8954-c1204e292b98";
      fsType = "ext4";
    };

    "/home" = {
      label = "MONKEHOME";
      options = ["noatime" "nodiratime" "discard"];
      device = "/dev/disk/by-uuid/98a141b0-951d-456d-8f65-ab6d6ba4746a";
      fsType = "ext4";
    };

    "/opt/os/arch" = {
      label = "ARCHROOT";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "discard"];
    };

    "/opt/os/ubuntu" = {
      label = "UBUNTUROOT";
      fsType = "ext4";
      options = ["noatime" "nodiratime" "discard"];
    };
  };
}
