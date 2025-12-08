{ config, lib, ... }:
{
  imports = [
    ./gui
    ./services

    ./security.nix
    ./networking.nix

    ./kanata.nix
    ./laptop.nix
    ./bluetooth.nix
  ];

  config = {
    networking = lib.mkIf config.networking.networkmanager.enable {
      firewall = {
        enable = lib.mkDefault true;
      };
      useDHCP = lib.mkDefault true;
    };

    system = {
      copySystemConfiguration = lib.mkDefault false;

      # auto-upgrade the system weekly
      autoUpgrade = lib.mkIf config.system.autoUpgrade.enable {
        dates = lib.mkDefault "weekly";
        allowReboot = lib.mkDefault false;
      };
    };

    console = {
      # use xkbOptions in tty.
      useXkbConfig = lib.mkDefault true;
      # TODO set a console font (for widescreen can use `config.feltnerm.hardware.display`)
      # font = "Lat2-Terminus16";
      # keyMap = cfg.locale.keymap;
    };

    documentation = lib.mkIf config.documentation.enable {
      # includeAllModules = lib.mkDefault true;
      dev.enable = lib.mkDefault true;
      man = {
        generateCaches = lib.mkDefault true;
      };
    };
  };
}
