{ lib, ... }:
{
  # Non-destructive dual-boot layout for markbook: reuse existing macOS EFI, add swap + ext4 root in free space
  config = {
    disko.devices = {
      disk.main = {
        type = "disk";
        # TODO
        device = lib.mkDefault "/dev/disk/by-id/replace-me";
        content = {
          type = "gpt";
          partitions = {
            # Reuse existing EFI partition created by macOS; do not create ESP here.
            swap = {
              # Set 'start' to the beginning of freed space after shrinking APFS in Disk Utility
              start = lib.mkDefault null; # e.g., "250GiB"
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
              };
            };
            root = {
              # If not setting start for swap, set start here to where free space begins
              start = lib.mkDefault null; # e.g., "258GiB"
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [
                  "noatime"
                  "nodiratime"
                ];
              };
            };
          };
        };
      };
    };
  };
}
