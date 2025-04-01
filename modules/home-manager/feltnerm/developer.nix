{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.developer;

  /**
    Quick search for a repo and `cd` to its directory
  */
  fzfReposZshExtra = ''
    function c() {
      cd -- $(fzf-repo "$1")
    }
  '';

  /**
    grep git commits
  */
  fzfGitCommits = pkgs.writeShellApplication {
    name = "fzf-git-commits";
    runtimeInputs = [
      pkgs.fzf
      pkgs.git
      pkgs.diff-so-fancy
    ];
    text = "git log --oneline | fzf --multi --preview 'git show {+1} | diff-so-fancy --color'";
  };

  /**
    search for my repos
  */
  fzfRepo = pkgs.writeShellApplication {
    name = "fzf-repo";
    runtimeInputs = [
      pkgs.fzf
      pkgs.eza
    ];
    text = builtins.readFile ./fzf-repo.sh;
  };
in
{
  options.feltnerm.developer = {
    enable = lib.mkEnableOption "developer";
    codeHome = lib.mkOption {
      description = "code directory";
      default = "${config.home.homeDirectory}/code";
    };
    git = {
      username = lib.mkOption {
        default = "";
      };
      email = lib.mkOption {
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zsh.initExtra = lib.mkIf (
        config.programs.zsh.enable && config.programs.fzf.enable
      ) fzfReposZshExtra;

      git = lib.mkIf config.programs.git.enable {
        userName = cfg.git.username;
        userEmail = cfg.git.email;
      };

      jujutsu = lib.mkIf config.programs.jujutsu.enable {
        settings = {
          name = cfg.git.username;
          inherit (cfg.git) email;
        };
      };

      nixvim = {
        plugins = {
          dap.enable = lib.mkDefault true;
          project-nvim.enable = lib.mkDefault true;
          rest.enable = lib.mkDefault true;
        };
      };
    };

    # home-manager configuration
    home = {
      sessionVariables = {
        CODE_HOME = "${cfg.codeHome}";
      };

      # developer-ey packages
      packages = lib.optionals config.programs.fzf.enable [
        fzfGitCommits
        fzfRepo
      ];
    };
  };
}
