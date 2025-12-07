{ lib, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/minimal.nix")
  ];

  # WSL does not require kernel modules configuration in most cases
  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  # Root filesystem placeholder (WSL manages filesystem mounts)
  fileSystems."/" = lib.mkDefault {
    device = "/dev/sda";
    fsType = "ext4";
  };

  # Disable swap for WSL
  swapDevices = [ ];

  # Enable DHCP on interfaces
  networking.useDHCP = lib.mkDefault true;
}
