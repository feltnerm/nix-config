{
  lib,
  ...
}:
{
  config.den.aspects.features.provides.nopasswd-wheel = {
    nixos.security.sudo.wheelNeedsPassword = false;
  };

  config.den.aspects.features.provides.security-base = {
    nixos = {
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
        rtkit.enable = lib.mkDefault true;
        sudo = {
          enable = lib.mkDefault true;
          execWheelOnly = lib.mkDefault true;
        };
      };
    };
  };
}
