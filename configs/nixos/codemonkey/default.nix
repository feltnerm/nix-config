{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];

  config = {
    networking.hostId = "30292576";
    networking.networkmanager.enable = true;

    system.stateVersion = "25.05";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "sr_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    # SSD support
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 1;
    };
    services.fstrim.enable = true;

    # disable the disk's scheduler
    # { boot.kernelParams = [ "elevator=none" ]; }

    # boot loader
    boot.loader.systemd-boot.enable = true;
    disko.devices = {
      disk = {
        main = {
          device = "/dev/nvme0n1";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "500M";
                type = "EF00";
                content = {
                  mountpoint = "/boot";
                  type = "filesystem";
                  format = "vfat";
                  mountOptions = [ "umask=0077" ];
                };
              };
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zroot";
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
          options.cachefile = "none";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };

          postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

          datasets = {
            "local/root" = {
              type = "zfs_fs";
              mountpoint = "/";
            };
            "local/nix" = {
              type = "zfs_fs";
              mountpoint = "/nix";
            };
            "safe/home" = {
              type = "zfs_fs";
              mountpoint = "/home";
              options."com.sun:auto-snapshot" = "true";
            };
            "safe/persist" = {
              type = "zfs_fs";
              mountpoint = "/persist";
              options."com.sun:auto-snapshot" = "true";
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
