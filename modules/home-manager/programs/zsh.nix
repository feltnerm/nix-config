{
  config,
  lib,
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

      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true; # allow terminal to track current directory
      autocd = true; # automatically enter a directory when typed
      #defaultKeymap = "vicmd";
      #completionInit = ''
      #  autoload -U compint
      #  zstyle ":completion:*" menu select
      #  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
      #  zmodload zsh/complist
      #  compinit
      #  _comp_options+=(globdots)

      #  bindkey -M menuselect 'h' vi-backward-char
      #  bindkey -M menuselect 'k' vi-up-line-or-history
      #  bindkey -M menuselect 'l' vi-forward-char
      #  bindkey -M menuselect 'j' vi-down-line-or-history
      #  bindkey -v '^?' backward-delete-char
      #'';

      syntaxHighlighting = {
        enable = true;
      };

      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        save = 10000;
        size = 10000;
        share = true;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      zplug = {
        enable = false;
        plugins = [];
      };

      # added to the top of .zshrc
      initExtraFirst = "";

      # added to .zshrc
      initExtra = ''
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line

        bindkey -v
        export KEYTIMEOUT=1
      '';

      #added to .zprofile
      profileExtra = "";
    };
  };
}
