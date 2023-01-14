{pkgs}: let
  name = "fzf-repo";
in
  pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [pkgs.fzf pkgs.exa];
    text = ''
      codeDir="$HOME/code"
      function _fzf-repo() {
        local query
        local repo
        local path

        local previewCommand
        previewCommand="exa --icons --git-ignore --group-directories-first --git -1"

        query="''${1:-}"
        repo=$(cd "${codeDir}" && tree -L 1 -dfiC -- * | fzf --query "$query" --scheme=path --filepath-word --ansi --header code --no-info --preview "$previewCommand {+}" --preview-label files)
        if [[ -n "$repo" ]]
        then
          path="$codeDir/$repo"
          echo -e "$path"
        fi
      }

      _fzf-repo "$@"
    '';
  }
