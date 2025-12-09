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

    yubikey = {
      enable = lib.mkEnableOption "Enable YubiKey integration (agent, tools)";
    };

  };
}
