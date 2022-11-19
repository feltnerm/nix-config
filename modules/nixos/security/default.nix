{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.feltnerm.security;
in {
  options.feltnerm.security = {
    enable = lib.mkOption {
      description = "Enable lightweight, sane security defaults.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable root and sudo access to `nix`
    nix.settings.allowed-users = ["root" "@wheel"];

    security = {
      # rtkit.enable = true;
      # apparmor = {
      #   enable = true;
      #   killUnconfinedConfinables = true;
      #   packages = [ pkgs.apparmor-profiles ];
      # };
      # pam.services.login.enableGnomeKeyring = true;
      # sudo.execWheelOnly = true;
      # protectKernelImage = true;
      # lockKernelModules = true;

      sudo = {
        enable = true;
        execWheelOnly = true;
        extraConfig = "Defaults env_reset,timestamp_timeout=5";
        extraRules = [
          {
            commands = [
              {
                command = "/run/current-system/sw/bin/nixos-rebuild";
                options = ["NOPASSWD"];
              }
            ];
          }
        ];
      };
    };
  };
}
