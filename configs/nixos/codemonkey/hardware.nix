{ lib, ... }:
{
  config = {
    networking.hostId = "30292576";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

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

    # SSD support
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 1;
    };
    services.fstrim.enable = true;

    # ZFS and disk layout via disko
    services.zfs.autoScrub.enable = true;
    services.zfs.trim.enable = true;
    disko.devices = {
      disk = {
        main = {
          device = "/dev/disk/by-id/nvme-KINGSTON_SFYRS1000G_50026B7686EE6A4F";
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
        sda = {
          type = "disk";
          device = "/dev/sda";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
        sdb = {
          type = "disk";
          device = "/dev/sdb";
          content = {
            type = "gpt";
            partitions = {
              zfs = {
                size = "100%";
                content = {
                  type = "zfs";
                  pool = "zdata";
                };
              };
            };
          };
        };
      };
      zpool = {
        zroot = {
          type = "zpool";
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

        zdata = {
          type = "zpool";
          mode = "mirror";
          rootFsOptions = {
            compression = "zstd";
            "com.sun:auto-snapshot" = "false";
          };
          postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zdata@blank$' || zfs snapshot zdata@blank";

          datasets = {
            "local/data" = {
              type = "zfs_fs";
              mountpoint = "/data";
              options.mountpoint = "legacy";
            };
            "safe/data/persist" = {
              type = "zfs_fs";
              mountpoint = "/data/persist";
              options."com.sun:auto-snapshot" = "true";
              options.mountpoint = "legacy";
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

    # Input/uinput + kanata device specifics
    hardware.uinput.enable = true;
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';
    users.groups.uinput = { };
    systemd.services.kanata-internalKeyboard.serviceConfig = {
      SupplimentaryGroups = [
        "input"
        "uinput"
      ];
    };
    services.kanata = {
      enable = true;
      keyboards.internalKeyboard = {
        devices = [
          "/dev/input/by-id/usb-Keychron_Keychron_K2-event-kbd"
        ];
        extraDefCfg = "process-unmapped-keys yes";
        # keep full keyboard config in main config to avoid duplication
      };
    };
  };
}
