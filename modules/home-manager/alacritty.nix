{
  config,
  lib,
  ...
}:
{
  programs.alacritty = lib.mkIf config.programs.alacritty.enable {
    settings = {
      window = {
        decorations = "Full";
        opacity = 0.99;
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
}
