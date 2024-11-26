{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.programs.zsh.enable {
    programs.zsh = {
      autosuggestion.enable = lib.mkDefault true;
      enableCompletion = lib.mkDefault true;
      enableVteIntegration = lib.mkDefault true; # allow terminal to track current directory
      autocd = lib.mkDefault true; # automatically enter a directory when typed
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
        enable = lib.mkDefault true;
      };

      history = {
        extended = lib.mkDefault true;
        ignoreDups = lib.mkDefault true;
        ignoreSpace = lib.mkDefault true;
        save = lib.mkDefault 10000;
        size = lib.mkDefault 10000;
        share = lib.mkDefault true;
        path = lib.mkDefault "${config.xdg.dataHome}/zsh/zsh_history";
      };

      zplug = {
        enable = lib.mkDefault false;
        plugins = [ ];
      };

      # added to the top of .zshrc
      initExtraFirst = "";

      # added to .zshrc
      initExtra = lib.mkDefault ''
        autoload edit-command-line; zle -N edit-command-line
        bindkey '^e' edit-command-line

        bindkey -v
        export KEYTIMEOUT=1
      '';

      #added to .zprofile
      profileExtra = lib.mkDefault "";
    };
  };
}
