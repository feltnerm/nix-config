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
        fonts = with pkgs; [
          comfortaa
          comic-neue
          fira
          fira-code
          fira-code-symbols
          ibm-plex
          inter
          iosevka
          iosevka
          jetbrains-mono
          lato
          material-design-icons
          nerdfonts
          noto-fonts
          noto-fonts-cjk
          noto-fonts-emoji
          powerline-fonts
          roboto
          source-sans
          twemoji-color-font
          work-sans
          (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
        ];

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
