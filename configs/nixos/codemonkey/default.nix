{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.disko.nixosModules.disko ];

  config = {
    system.stateVersion = "25.05";
    nixpkgs.hostPlatform = "x86_64-linux";
    networking.hostId = "30292576";

    nix.settings.trusted-users = [ "mark" ];

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

    networking.networkmanager.enable = true;
    networking.firewall.enable = false;

    users.users.mark.shell = pkgs.zsh;

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
    # disable the disk's scheduler
    # { boot.kernelParams = [ "elevator=none" ]; }

    services.openssh.enable = true;
    services.pipewire.enable = true;

    # gui (greeter, hyprland, ...)
    services.greetd.enable = true;
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };
    environment.systemPackages = [ pkgs.kitty ];

    # keyboard mapping
    # https://dev.to/shanu-kumawat/how-to-set-up-kanata-on-nixos-a-step-by-step-guide-1jkc
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
      keyboards = {
        internalKeyboard = {
          devices = [
            # TODO upgrade keyboard
            "/dev/input/by-id/usb-Keychron_Keychron_K2-event-kbd"
          ];
          extraDefCfg = "process-unmapped-keys yes";
          config = ''
            (defsrc
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              tab  q    w    e    r    t    y    u    i    o    p    [    ]    \
              caps a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rmet rctl
            )

            (defalias
              cec (tap-hold 200 200 esc lctl)
              sym (tap-hold 200 200 tab (layer-toggle symbols))
            )

            (deflayer default
              esc  f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
              grv  1    2    3    4    5    6    7    8    9    0    -    =    bspc
              @sym q    w    e    r    t    y    u    i    o    p    [    ]    \
              @cec a    s    d    f    g    h    j    k    l    ;    '    ret
              lsft z    x    c    v    b    n    m    ,    .    /    rsft
              lctl lmet lalt           spc            ralt rmet rctl
            )

            (deflayer symbols
              _    _    _    _    _    _    _    _    _    _    _    _    _
              _    S-1  S-2  S-3  S-4  S-5  S-6  S-7  S-8  S-9  S-0  _    _    _
              _    S-5  S-6  S-7  S-8  _    _    _    _    S-9  S-0  _    _    _
              _    _    _    del  _    _    left down up   rght _    _    _
              _    _    _    _    _    _    _    _    _    _    _    _
              _    _    _              _              _    _    _
            )

          '';
        };
      };
    };

    # boot loader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = false; # NOTE: rely on BIOS boot order
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
