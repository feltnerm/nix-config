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

    profile = lib.mkOption {
      description = "Preset configuration profile for package selection.";
      type = lib.types.enum [
        "minimal"
        "standard"
        "full"
      ];
      default = "standard";
    };

    ssh = {
      signingKey = lib.mkOption {
        description = "SSH public key to use for Git signing (path or key string).";
        type = lib.types.str;
        default = "~/.ssh/id_ed25519_sk.pub";
        example = "~/.ssh/id_ed25519_sk.pub";
      };
    };

    packages = {
      development = lib.mkEnableOption "Include development tools packages";
      networking = lib.mkEnableOption "Include networking tools packages";
      fun = lib.mkEnableOption "Include fun/toys packages";
      yubikey = lib.mkEnableOption "Include YubiKey related packages";
      custom = lib.mkEnableOption "Include custom local packages";
    };

    yubikey = {
      enable = lib.mkEnableOption "Enable YubiKey integration (agent, tools)";
    };

  };
}
