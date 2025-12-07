{ lib, ... }:
{
  # Markbook hardware config (MacBook Pro 13" Late 2013 - MacBookPro11,1)
  # Notes:
  # - Filesystem labels are placeholders; set during installation
  # - Partition scheme: EFI (vfat, 512MB) + swap (8GB) + root (ext4)
  # - Uses nixos-hardware apple-macbook-pro-11-1 via default.nix imports

  config = {
    networking.hostId = "5749b1eb";

    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    # SSD support & swappiness
    boot.kernel.sysctl = {
      "vm.swappiness" = lib.mkDefault 10;
    };
    services.fstrim.enable = true;

    # Camera (FaceTime HD)
    hardware.facetimehd.enable = true;

    # Touchpad defaults (libinput)
    services.libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
      };
    };

    # Filesystems (update labels if different)
    fileSystems."/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
      ];
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [ "umask=0077" ];
    };

    swapDevices = [
      {
        device = "/dev/disk/by-label/swap";
      }
    ];

    # Kanata uinput rules and device config for Keychron K2
    hardware.uinput.enable = true;
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';
    users.groups.uinput = { };
    systemd.services.kanata-internalKeyboard.serviceConfig = {
      SupplementaryGroups = [
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
      };
    };

    # Fine-tuning notes:
    # - Hyprland scale: configure monitor scaling in home-manager.
    # - Function keys default behavior: set `boot.kernelParams = [ "hid_apple.fnmode=2" ];` if desired.
    #   Example:
    #   boot.kernelParams = [ "hid_apple.fnmode=2" ];
    # - Backlight control: `programs.light.enable = true` in default.nix; brightnessctl is included.
    # - Power tuning: `powertop` included; run `sudo powertop --auto-tune` periodically.
  };
}
