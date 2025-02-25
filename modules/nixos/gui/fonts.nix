{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.gui.fonts;
in
{
  config = lib.mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        # sans fonts
        comic-neue
        source-sans
        nerd-fonts.hack
        nerd-fonts.blex-mono
        nerd-fonts.iosevka
        nerd-fonts.jetbrains-mono
      ];

      enableDefaultPackages = lib.mkDefault true;

      fontconfig = {
        enable = lib.mkDefault true;
        defaultFonts = {
          monospace = [
            "Iosevka Term Nerd Font Complete Mono"
            "Iosevka Nerd Font"
            "Noto Color Emoji"
          ];
          sansSerif = [
            "Iosevka Nerd Font"
            "Noto Color Emoji"
          ];
          serif = [
            "Iosevka Nerd Font"
            "Noto Color Emoji"
          ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
