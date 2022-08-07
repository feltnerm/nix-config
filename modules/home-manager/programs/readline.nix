{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.readline;
in {
  options.feltnerm.programs.readline = {
    enable = lib.mkOption {
      description = "Enable custom readline.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.readline = lib.mkIf cfg.enable {
      enable = true;
      bindings = {
        "Control-a" = "beginning-of-line";
        "Control-b" = "backward-char";
        "Control-d" = "delete-char";
        "Control-e" = "end-of-line";
        "Control-f" = "forward-char";
        "Control-k" = "kill-line";
        "Control-n" = "next-history";
        "Control-p" = "previous-history";
      };
      extraConfig = ''
        set editing-mode vi
        set keymap vi-insert

        # Make Tab autocomplete regardless of filename case
        set completion-ignore-case on

        # List all matches in case multiple possible completions are possible
        set show-all-if-ambiguous on

        # Immediately add a trailing slash when autocompleting symlinks to directories
        set mark-symlinked-directories on

        # Use the text that has already been typed as the prefix for searching through
        # commands (i.e. more intelligent Up/Down behavior)
        "\e[B": history-search-forward
        "\e[A": history-search-backward

        # Do not autocomplete hidden files unless the pattern explicitly begins with a dot
        set match-hidden-files off

        # Show all autocomplete results at once
        set page-completions off

        # If there are more than 200 possible completions for a word, ask to show them all
        set completion-query-items 200

        # Show extra file information when completing, like `ls -F` does
        set visible-stats on

        # Be more intelligent when autocompleting by also looking at the text after
        # the cursor. For example, when the current line is "cd ~/src/mozil", and
        # the cursor is on the "z", pressing Tab will not autocomplete it to "cd
        # ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
        # Readline used by Bash 4.)
        set skip-completed-text on

        # Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
        set input-meta on
        set output-meta on
        set convert-meta off
      '';
    };
  };
}
