{
  pkgs,
  config,
  ...
}: let
  # TODO organize these helpers
  # can be sourced lazily at runtime, or sourced at shell load
  # grep git commits
  fzfGitCommits = pkgs.writeShellApplication {
    name = "fzf-git-commits";
    runtimeInputs = [pkgs.fzf pkgs.git pkgs.diff-so-fancy];
    text = "git log --oneline | fzf --multi --preview 'git show {+1} | diff-so-fancy --color'";
  };

  # livegrep in files
  fzfFiles = pkgs.writeShellApplication {
    name = "fzf-files";
    runtimeInputs = [pkgs.fzf pkgs.bat];
    text = builtins.readFile ./fzf-files.sh;
  };

  # search for my repos
  fzfRepo = pkgs.writeShellApplication {
    name = "fzf-repo";
    runtimeInputs = [pkgs.fzf pkgs.exa];
    text = builtins.readFile ./fzf-repo.sh;
  };
in {
  config = {
    home.shellAliases = {};

    home.sessionVariables = {};

    home.packages = [
      fzfGitCommits
      fzfFiles
      fzfRepo
    ];

    programs.zsh.initExtra = ''
      function f() {
        vim -- $(fzf-files "$1")
      }

      function c() {
        cd -- $(fzf-repo "$1")
      }
    '';
  };
}
