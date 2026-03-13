{
  lib,
  config,
  ...
}:
let
  cfg = config.feltnerm.yubikey;
in
{
  options.feltnerm.yubikey = {
    enable = lib.mkEnableOption "YubiKey integration";
    enablePiv = lib.mkOption {
      description = "Enable PIV (smartcard) integration via yubikey-agent.";
      type = lib.types.bool;
      default = true;
    };
    enableFido2 = lib.mkOption {
      description = "Enable FIDO2 support for security-key backed SSH (libsk/libfido2).";
      type = lib.types.bool;
      default = true;
    };
  };

  config.den.aspects.features.provides.smart-card = {
    nixos.services.pcscd.enable = true;

    homeManager =
      { pkgs, lib, ... }:
      {
        services.yubikey-agent.enable = lib.mkIf cfg.enable (lib.mkDefault cfg.enablePiv);

        services.gpg-agent.enable = lib.mkIf (cfg.enable && cfg.enablePiv) (lib.mkForce false);

        home.packages = lib.mkIf cfg.enable (
          with pkgs;
          [
            yubikey-manager
            yubikey-personalization
          ]
          ++ lib.optionals cfg.enablePiv [
            yubikey-agent
          ]
          ++ lib.optionals (cfg.enableFido2 && pkgs ? libsk-libfido2) [
            libsk-libfido2
          ]
        );
      };
  };
}
