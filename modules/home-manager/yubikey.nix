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
  config = lib.mkIf (hmEnabled && cfg.enable) {
    services.yubikey-agent.enable = lib.mkDefault true;

    # Ensure GnuPG agent is disabled when using yubikey-agent
    services.gpg-agent.enable = lib.mkForce false;

    home.packages = with pkgs; [
      yubikey-agent
      yubikey-manager
      yubikey-personalization
    ];
  };
}
