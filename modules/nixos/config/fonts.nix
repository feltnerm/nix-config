{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.feltnerm.config.fonts.enable {
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
