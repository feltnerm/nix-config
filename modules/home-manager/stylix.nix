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
