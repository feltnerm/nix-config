{
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.security;
in {
  options.feltnerm.security = {
    enable = lib.mkEnableOption "lightweight, sane security defaults.";
  };

  config = lib.mkIf cfg.enable {
    # Enable root and sudo access to `nix`
    nix.settings.allowed-users = ["root" "@wheel"];
    nix.settings.trusted-users = ["root" "@wheel"];

    security = {
      # TODO
      # rtkit.enable = true;
      # apparmor = {
      #   enable = true;
      #   killUnconfinedConfinables = true;
      #   packages = [ pkgs.apparmor-profiles ];
      # };
      # pam.services.login.enableGnomeKeyring = true;
      # protectKernelImage = true;
      # lockKernelModules = true;

      sudo = {
        enable = true;
        execWheelOnly = true;
        extraConfig = "Defaults env_reset,timestamp_timeout=5";
      };

      doas = {
        enable = true;
        extraRules = [
          {
            groups = ["wheel"];
            noPass = false;
            keepEnv = true;
            persist = true;
          }
        ];
      };
    };
  };
}
