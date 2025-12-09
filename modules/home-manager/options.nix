{
  lib,
  feltnermTheme ? null,
  ...
}:
{
  options.feltnerm = {
    enable = lib.mkEnableOption "feltnerm";
    theme = lib.mkOption {
      description = "Global theme name for HM profiles.";
      type = lib.types.str;
      default = if feltnermTheme != null then feltnermTheme else "gruvbox-dark-hard";
      example = "catppuccin-mocha";
    };

    ssh = {
      signingKey = lib.mkOption {
        description = "SSH public key to use for Git signing (path or key string).";
        type = lib.types.str;
        default = "";
        example = "~/.ssh/id_ed25519_sk.pub";
      };
    };

    yubikey = {
      enable = lib.mkEnableOption "Enable YubiKey integration (agent, tools)";
    };

  };
}
