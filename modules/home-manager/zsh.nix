{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.programs.zsh.enable {
    programs.zsh = {
      enableCompletion = lib.mkDefault true;
      enableVteIntegration = lib.mkDefault true; # allow terminal to track current directory
      autocd = lib.mkDefault true; # automatically enter a directory when typed
      defaultKeymap = lib.mkDefault "viins";

      autosuggestion.enable = lib.mkDefault true;
      syntaxHighlighting.enable = lib.mkDefault true;

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

      # added to .zshrc
      initContent = ''
        autoload edit-command-line
        zle -N edit-command-line
        bindkey "^X^E" edit-command-line
        #bindkey -M vicmd '^e' edit-command-line
        #bindkey -M vicmd ' ' edit-command-line

        bindkey -v
        export KEYTIMEOUT=1
      '';
    };
  };
}
