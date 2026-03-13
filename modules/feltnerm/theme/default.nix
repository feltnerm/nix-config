{ lib, ... }:
let
  themeToPolarity = theme: if theme == "catppuccin-latte" then "light" else "dark";
in
{

  config.den.aspects.features.provides.theme = theme: {
    homeManager =
      {
        pkgs,
        ...
      }:
      {
        stylix = {
          enable = lib.mkDefault true;
          base16Scheme = lib.mkDefault "${pkgs."base16-schemes"}/share/themes/${theme}.yaml";
          polarity = lib.mkDefault (themeToPolarity theme);
        };
      };
  };
}
