{ lib, ... }:
{
  options.feltnerm = {
    enable = lib.mkEnableOption "feltnerm";
    theme = lib.mkOption {
      description = "Global theme name for HM profiles.";
      type = lib.types.str;
      default = "gruvbox-dark-hard";
      example = "catppuccin-mocha";
    };
  };
}
