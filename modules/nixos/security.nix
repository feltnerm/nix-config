{
  lib,
  ...
}:
{
  # Enable root and sudo access to `nix`
  nix.settings.allowed-users = lib.mkDefault [
    "root"
    "@wheel"
  ];
  nix.settings.trusted-users = lib.mkDefault [
    "root"
    "@wheel"
  ];
  security = {
    rtkit.enable = true;
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
      enable = lib.mkDefault true;
      execWheelOnly = true;
      extraConfig = "Defaults env_reset,timestamp_timeout=5";
      extraRules = [
        {
          commands = [
            {
              command = "/run/current-system/sw/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };
}
