{
  config,
  lib,
  hostname,
  username,
  ...
}: let
  cfg = config.feltnerm.networking;
in {
  options.feltnerm.networking = {
    enable = lib.mkEnableOption "networking";

    interfaces = lib.mkOption {
      description = "List of networking interfaces to enable";
      type = with lib.types; listOf str;
      default = [];
    };
  };

  config = let
    networkCfg =
      builtins.listToAttrs
      (map
        (n: {
          name = "${n}";
          value = {useDHCP = true;};
        })
        cfg.interfaces);
  in {
    users.extraGroups = {
      network.members = [username];
      networkmanager.members = [username];
    };

    networking = lib.mkIf cfg.enable {
      useDHCP = lib.mkDefault true;
      hostName = hostname;
      networkmanager.enable = lib.mkDefault true;
      networkmanager.wifi.macAddress = "random";
      # TODO systemd.services.NetworkManager-wait-online.enable = false;

      firewall = {
        enable = lib.mkDefault true;
      };

      interfaces = networkCfg;
    };
  };
}
