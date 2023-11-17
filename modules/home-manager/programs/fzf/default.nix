{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.programs.fzf;

  # TODO use fzf-tmux
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
    runtimeInputs = [pkgs.fzf pkgs.eza];
    text = builtins.readFile ./fzf-repo.sh;
  };

  fzfFilesZshExtra = ''
    function f() {
      vim -- $(fzf-files "$1")
    }
  '';
in {
  options.feltnerm.programs.fzf = {
    enable = lib.mkOption {
      description = "Enable fzf and some shell helpers.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      tmux = {
        # TODO
        #enableShellIntegration = true;
      };
    };

    home = {
      packages = [
        pkgs.fzf

        fzfGitCommits
        fzfFiles
        fzfRepo
      ];
    };

    programs.zsh.initExtra = fzfFilesZshExtra;
  };
}
