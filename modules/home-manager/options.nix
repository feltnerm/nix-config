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

    profile = lib.mkOption {
      description = "Preset configuration profile for package selection.";
      type = lib.types.enum [ "minimal" "standard" "full" ];
      default = "standard";
    };

    packages = {
      development = lib.mkEnableOption "Include development tools packages";
      networking = lib.mkEnableOption "Include networking tools packages";
      fun = lib.mkEnableOption "Include fun/toys packages";
      yubikey = lib.mkEnableOption "Include YubiKey related packages";
      custom = lib.mkEnableOption "Include custom local packages";
    };
  };
}
