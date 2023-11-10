{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.alacritty;
  #theme = ./base16-gruvbox-dark-soft-256.yml;
in {
  options.feltnerm.programs.alacritty = {
    enable = lib.mkOption {
      description = "Enable alacritty GUI terminal.";
      default = false;
    };
  };

  config = {
    programs.alacritty = {
      inherit (cfg) enable;
      settings = {
        window = {
          decorations = "Full";
          opacity = 0.99;
          padding.x = 8;
          padding.y = 24;
          dynamic_padding = false;
          dynamic_title = true;
        };
        draw_bold_text_with_bright_colors = false;
        live_config_reload = true;
        mouse = {
          hide_when_typing = true;
        };

        # Base16 Gruvbox dark, soft 256 - alacritty color config
        # Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
        colors = {
          # Default colors
          primary = {
            background = "0x32302f";
            foreground = "0xd5c4a1";
          };

          # Colors the cursor will use if `custom_cursor_colors` is true
          cursor = {
            text = "0x32302f";
            cursor = "0xd5c4a1";
          };

          # Normal colors
          normal = {
            black = "0x32302f";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xd5c4a1";
          };

          # Bright colors
          bright = {
            black = "0x665c54";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xfbf1c7";
          };

          indexed_colors = [
            {
              index = 16;
              color = "0xfe8019";
            }
            {
              index = 17;
              color = "0xd65d0e";
            }
            {
              index = 18;
              color = "0x3c3836";
            }
            {
              index = 19;
              color = "0x504945";
            }
            {
              index = 20;
              color = "0xbdae93";
            }
            {
              index = 21;
              color = "0xebdbb2";
            }
          ];
        };

        font = {
          size = 18;
          normal = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Thin Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "SemiBold Italic";
          };
        };
      };
    };

    home.packages = with pkgs; [
      alacritty
    ];
  };
}
