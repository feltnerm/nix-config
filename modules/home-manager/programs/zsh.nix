{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.programs.zsh;
in {
  options.feltnerm.programs.zsh = {
    enable = lib.mkOption {
      description = "Enable zsh";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      # zsh configuration
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      enableSyntaxHighlighting = true;
      enableVteIntegration = true; # allow terminal to track current directory
      autocd = true; # automatically enter a directory when typed
      #defaultKeymap = "vicmd";

      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        save = 10000;
        size = 10000;
        share = true;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      #zplug = {
      #  enable = true;
      #  #plugins = [
      #  #  "bhilburn/powerlevel9k"
      #  #  "willghatch/zsh-saneopt"
      #  #];
      #};

      # added to the top of .zshrc
      initExtraFirst = "";
      # added to .zshrc
      initExtra = ''        ;
              tmuxn() {
                if [[ -z "$1" ]]
                then
                  tmux new-session -s $(basename $(pwd))
                else
                  tmux new-session -s "$1"
                fi
              }

              tmuxa() {
                if [[ -z "$1" ]]
                then
                  tmux attach-session -t $(basename $(pwd))
                else
                  tmux attach-session -t "$1"
                fi
              }
      '';
      #added to .zprofile
      profileExtra = "";
    };
  };
}
