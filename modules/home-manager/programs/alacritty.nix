{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.alacritty;
in {
  options.feltnerm.programs.alacritty = {
    enable = lib.mkOption {
      description = "Enable alacritty";
      default = false;
    };
  };

  config = {
    programs.zsh = lib.mkIf cfg.enable {
      initExtra = ''
        if [[ "$TERM" != "" && "$TERM" == "alacritty" ]]
        then
            precmd()
            {
                print -Pn "$(whoami)@$(hostname):%~\a"
            }

            preexec()
            {
                # output current executed command with parameters
                echo -en "\e]0;$(whoami)@$(hostname): $1\a"
            }
        fi
      '';
    };

    programs.alacritty = {
      inherit (cfg) enable;
      settings = {
        window = {
          decorations = "transparent";
          opacity = 0.99;
          padding.x = 16;
          padding.y = 24;
          dynamic_padding = false;
          dynamic_title = true;
        };
        bell = {
          animation = "EaseOutExpo";
          duration = 50;
          color = "0xffffff";
        };
        draw_bold_text_with_bright_colors = false;
        live_config_reload = true;

        # gruvbox
        colors = {
          primary = {
            background = "0x282828";
            foreground = "0xebdbb2";
          };
          normal = {
            black = "0x282828";
            red = "0xcc241d";
            green = "0x98971a";
            yellow = "0xd79921";
            blue = "0x458588";
            magenta = "0xb16286";
            cyan = "0x689d6a";
            white = "0xa89984";
          };
          bright = {
            black = "0x928374";
            red = "0xfb4934";
            green = "0xb8bb26";
            yellow = "0xfabd2f";
            blue = "0x83a598";
            magenta = "0xd3869b";
            cyan = "0x8ec07c";
            white = "0xebdbb2";
          };
        };

        font = {
          size = 16;
          normal = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "ExtraBold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font Mono";
            style = "ExtraLightItalic";
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
