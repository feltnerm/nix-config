{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.feltnerm.yubikey;
  hmEnabled = config.feltnerm.enable or false;
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

  config = lib.mkIf (hmEnabled && cfg.enable) {
    services.yubikey-agent.enable = lib.mkDefault cfg.enablePiv;

    # Ensure GnuPG agent is disabled when using yubikey-agent (PIV)
    services.gpg-agent.enable = lib.mkIf cfg.enablePiv (lib.mkForce false);

    home.packages =
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
      ];
  };
}
