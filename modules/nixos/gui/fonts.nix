{
  config,
  lib,
  pkgs,
  ...
}:
{
  fonts = lib.mkIf config.fonts.fontconfig.enable {
    packages = with pkgs; [
      # sans fonts
      comic-neue
      source-sans

      # monospace
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.blex-mono
    ];

    enableDefaultPackages = lib.mkDefault true;

    fontconfig = {
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
}
