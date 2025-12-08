{ lib, pkgs, ... }:
{
  config = {
    # Pure ephemeral live system
    fileSystems."/" = lib.mkForce {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [
        "mode=0755"
        "size=80%"
      ];
    };

    # Avoid mounting host-specific filesystems
    swapDevices = lib.mkForce [ ];

    # GUI stays per host config; here only small QoL
    environment.systemPackages = with pkgs; [
      neofetch
    ];

    # Banner to remind it's ephemeral
    environment.etc."issue".text = ''
      NixOS Live ISO (ephemeral)\n
      Changes are not persisted across reboots.\n
    '';
  };
}
