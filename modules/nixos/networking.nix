{ config, lib, ... }:
{
  options = {
    feltnerm.networking = {
      enable = lib.mkEnableOption "enable shared networking defaults";
      firewallEnable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable firewall by default (mkDefault).";
      };
      useDHCP = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable DHCP by default (mkDefault).";
      };
    };
  };

  config = lib.mkIf (config.feltnerm.networking.enable or true) {
    networking = {
      networkmanager.enable = lib.mkDefault true;
      firewall.enable = lib.mkDefault config.feltnerm.networking.firewallEnable;
      useDHCP = lib.mkDefault config.feltnerm.networking.useDHCP;
    };
  };
}
