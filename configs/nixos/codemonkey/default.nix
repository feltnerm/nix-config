{ inputs, lib, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];

  config = {
    system.stateVersion = "25.05";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

    # SSD support
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 1;
    };
    services.fstrim.enable = true;

    # boot loader
    boot.loader.grub.device = "/dev/sda/";
    disko.devices = {
      disk = {
        main = {
          device = "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
      nodev = {
        "/tmp" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=200M"
          ];
        };
      };
    };
  };
}
