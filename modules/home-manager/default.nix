{...}: {
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./programs
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  systemd.user.startServices = true;

  programs = {
    home-manager.enable = true;
  };
}
