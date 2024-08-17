{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.fonts;
in {
  options.feltnerm.fonts = {
    enable = lib.mkEnableOption "fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        # sans fonts
        comic-neue
        source-sans

        (nerdfonts.override {
          fonts = [
            "Hack"
            "IBMPlexMono"
            "Iosevka"
            "JetBrainsMono"
          ];
        })
      ];

      enableDefaultPackages = true;

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
