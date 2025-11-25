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
      zsh.initContent = lib.mkIf (
        config.programs.zsh.enable && config.programs.fzf.enable
      ) fzfReposZshExtra;

      git = lib.mkIf config.programs.git.enable {
        settings.user = {
          name = cfg.git.username;
          inherit (cfg.git) email;
        };
      };

      jujutsu = lib.mkIf config.programs.jujutsu.enable {
        settings = {
          user = {
            name = cfg.git.username;
            inherit (cfg.git) email;
          };
        };
      };

      nixvim = {
        plugins = {
          # git
          fugitive.enable = lib.mkDefault true;
          gitblame.enable = lib.mkDefault true;
          gitgutter.enable = lib.mkDefault true;

          # dap
          dap.enable = lib.mkDefault true;

          # project
          project-nvim.enable = lib.mkDefault true;

          rest.enable = lib.mkDefault true;

          treesitter.grammarPackages = pkgs.vimPlugins.nvim-treesitter.passthru.allGrammars;
          # treesitter.grammarPackages = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;

          # LSP
          lsp = {
            enable = lib.mkDefault true;
            servers = {
              bashls.enable = lib.mkDefault true;
              gleam.enable = lib.mkDefault true;
              # TODO: enable for text, git commits, etc.
              harper_ls.enable = lib.mkDefault false;
              cssls.enable = lib.mkDefault true;
              html.enable = lib.mkDefault true;
              jsonls.enable = lib.mkDefault true;
              lua_ls.enable = lib.mkDefault true;
              marksman.enable = lib.mkDefault true;
              nil_ls = {
                enable = lib.mkDefault true;
                settings = {
                  formatting = {
                    command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
                  };
                  nix = {
                    flake = {
                      autoArchive = true;
                    };
                  };
                };
              };
              rust_analyzer = {
                enable = lib.mkDefault true;
                installCargo = lib.mkDefault false;
                installRustc = lib.mkDefault false;
              };
              ts_ls.enable = lib.mkDefault true;
              vimls.enable = lib.mkDefault true;
              yamlls.enable = lib.mkDefault true;
              zls.enable = lib.mkDefault true;
            };
          };
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
