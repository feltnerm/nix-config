_: {
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./config
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
