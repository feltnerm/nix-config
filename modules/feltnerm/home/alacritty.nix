{ lib, ... }:
{
  config.den.aspects.features.provides.alacritty = {
    homeManager = {
      programs.alacritty.enable = lib.mkDefault true;

      programs.alacritty = {
        settings = {
          window = {
            decorations = "Full";
            opacity = lib.mkForce 0.99;
            padding.x = 8;
            padding.y = 24;
            dynamic_padding = false;
            dynamic_title = true;
          };
          live_config_reload = true;
          mouse = {
            hide_when_typing = true;
          };
        };
      };
    };
  };
}
