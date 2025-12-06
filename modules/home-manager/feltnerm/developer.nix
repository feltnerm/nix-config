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
      type = lib.types.str;
      default = "${config.home.homeDirectory}/code";
      example = "${config.home.homeDirectory}/Projects";
    };
    git = {
      username = lib.mkOption {
        description = "Git user name";
        type = lib.types.str;
        default = "";
      };
      email = lib.mkOption {
        description = "Git user email";
        type = lib.types.str;
        default = "";
      };
    };
    ai = {
      enable = lib.mkEnableOption "ai";
      provider = lib.mkOption {
        description = "AI model provider";
        default = "copilot";
        type = lib.types.enum [ "copilot" ];
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services = {
      ollama = lib.mkIf cfg.ai.enable {
        # fails on aarm64-darwin
        enable = lib.mkDefault false;
      };
    };

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

      gh = lib.mkIf config.programs.git.enable {
        enable = lib.mkDefault true;
      };

      jujutsu = lib.mkIf config.programs.jujutsu.enable {
        settings = {
          user = {
            name = cfg.git.username;
            inherit (cfg.git) email;
          };
        };
      };

      opencode = lib.mkIf cfg.ai.enable {
        enable = lib.mkDefault true;
      };

      nixvim = {
        extraPlugins = [ ];
        plugins = {
          snacks = {
            enable = lib.mkDefault true;
            settings = {
              input.enabled = lib.mkDefault true;
              picker.enabled = lib.mkDefault true;
              terminal.enabled = lib.mkDefault true;
            };
          };

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

          opencode = {
            enable = lib.mkDefault cfg.ai.enable;
            settings = {
              provider = {
                enabled = lib.mkDefault "snacks";
              };
            };
          };

          copilot-lua = lib.mkIf (cfg.ai.enable && cfg.ai.provider == "copilot") {
            enable = lib.mkDefault true;
            settings = {
              # let blink take over
              suggestion = {
                enabled = false;
              };
              panel = {
                enabled = false;
              };
            };
          };

          blink-copilot.enable = lib.mkDefault (cfg.ai.enable && cfg.ai.provider == "copilot");
          blink-cmp = {
            enable = lib.mkDefault true;
            # keymaps / completion inspired by intellij
            settings = {
              appearance = {
                nerd_font_variant = "mono";
              };
              sources = {
                default = [
                  "lsp"
                  "snippets"
                  "path"
                ]
                ++ lib.optionals cfg.ai.enable [ cfg.ai.provider ]
                ++ [
                  "buffer"
                ];
                providers = {
                  # Give LSP a slight edge over other core sources
                  lsp.score_offset = 5;

                  buffer.score_offset = -7;

                  # Adjust Copilot's rank as needed (e.g., lower it to prevent it from
                  # obscuring all other suggestions, which is common practice).
                  copilot = lib.mkIf (cfg.ai.provider == "copilot") {
                    enabled = lib.mkDefault cfg.ai.enable;
                    name = "copilot";
                    module = "blink-copilot";
                    async = true;
                    score_offset = -100;
                  };
                };
              };
              completion = {
                list = {
                  selection = {
                    preselect = false;
                  };
                };
                documentation = {
                  auto_show = true;
                };
                ghost_text = {
                  enabled = true;
                };
              };
              fuzzy.implementation = "prefer_rust_with_warning";
              keymap = {
                preset = "super-tab";
                # Explicitly redefine <Tab> for multi-purpose use
                # Note: When overriding keymaps, you must use a Lua string
                # to specify the command array.
                "<Tab>" = [
                  "select_next"
                  "snippet_forward"
                  "accept"
                  "fallback"
                ];

                # Explicitly redefine <S-Tab> (Shift+Tab)
                "<S-Tab>" = [
                  "select_prev"
                  "snippet_backward"
                ];

                # Enter accepts the completion
                "<CR>" = [
                  "accept"
                  "fallback"
                ];

                # Manually show completion/documentation
                "<C-Space>" = [
                  "show"
                  "show_documentation"
                ];
              };
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
