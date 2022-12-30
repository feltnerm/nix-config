{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.feltnerm.system.networking;
in {
  options.feltnerm.system.networking = {
    enableNetworkManager = lib.mkOption {
      description = "Enable Network Manager";
      default = false;
    };

    enableFirewall = lib.mkOption {
      description = "Enable firewall";
      default = false;
    };

    preferExplicitNetworkAccess = lib.mkOption {
      description = "Explicitly give interfaces networking access";
      default = true;
    };

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
    networking = {
      networkmanager.enable = cfg.enableNetworkManager;
      firewall = {
        enable = cfg.enableFirewall;
      };
      useDHCP = !cfg.preferExplicitNetworkAccess;
      interfaces = networkCfg;
    };
  };
}
