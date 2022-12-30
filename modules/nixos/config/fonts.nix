{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.config.fonts;
in
  with lib; {
    options.feltnerm.config.fonts = {
      enable = lib.mkOption {
        description = "Enable pretty fonts.";
        default = false;
      };
    };

    config = lib.mkIf cfg.enable {
      fonts = {
        enableDefaultFonts = false;

        fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [
              "Iosevka Term Nerd Font Complete Mono"
              "Iosevka Nerd Font"
              "Noto Color Emoji"
            ];
            sansSerif = ["Iosevka Nerd Font" "Noto Color Emoji"];
            serif = ["Iosevka Nerd Font" "Noto Color Emoji"];
            emoji = ["Noto Color Emoji"];
          };
        };
      };
    };
  }
