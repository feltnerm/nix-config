{
  lib,
  config,
  username,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.virtualization;
in {
  options.feltnerm.virtualization = {
    enable = lib.mkEnableOption "virtualization";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      virt-manager
    ];

    users.extraGroups = {
      libvirtd.members = [username];
      vboxusers.members = [username];
    };

    virtualisation = {
      docker.enable = true;
      podman.enable = true;
      libvirtd.enable = true;
      virtualbox.host.enable = true;
    };
  };
}
