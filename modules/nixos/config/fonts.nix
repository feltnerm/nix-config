{
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.feltnerm.config.fonts.enable {
    fonts = {
      enableDefaultPackages = lib.mkDefault true;

      fontconfig = {
        enable = lib.mkDefault true;
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
