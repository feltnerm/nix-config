{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm;
in
{
  stylix = {
    enable = lib.mkDefault true;
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";
    polarity = lib.mkDefault "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
  };
}
