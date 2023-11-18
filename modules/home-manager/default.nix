{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../common.nix

    ./programs
    ./profiles
    ./services
  ];

  # settings and packages available to all home-manager profiles

  config = {
    systemd.user.startServices = lib.mkDefault true;

    services.home-manager.autoUpgrade = {
      enable = false;
      frequency = "daily";
    };

    home.enableNixpkgsReleaseCheck = true;

    programs.bash.enable = true;
  };
}
