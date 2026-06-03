{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.developer.ai;
in
{
  # Only apply when developer and AI are enabled
  config = lib.mkIf cfg.enable {
    programs.nixvim.plugins.codecompanion = {
      enable = lib.mkDefault true;
      settings = {
        display = {
          action_palette = {
            provider = lib.mkDefault "snacks";
          };
        };
        interactions = {
          chat = {
            adapter = "opencode";
          };
        };
      };
    };

    home.shellAliases.nvimz = ''nvim -c "lua vim.defer_fn(function() vim.cmd('CodeCompanionChat Toggle') end, 100)"'';

    programs.git = lib.mkIf config.programs.git.enable {
      ignores = [
        ".opencode"
        ".aider"
      ];
    };

    home.packages = with pkgs; [
      nono
      rtk
      llmfit
      spec-kit
      goose-cli
      pi-coding-agent
    ];

    services = {
      ollama = {
        # fails on aarm64-darwin
        enable = lib.mkDefault true;
      };
    };

    programs = {
      gemini-cli = {
        enable = lib.mkDefault true;
      };
      # OpenCode CLI configuration and agents
      opencode = {
        enable = lib.mkDefault true;
        enableMcpIntegration = lib.mkDefault true;
        agents = { };
        settings = {
          default_agent = lib.mkDefault "orchestrator";

          model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
          small_model = lib.mkDefault "github-copilot/claude-haiku-4.5";

          # github-copilot is a built-in provider
          enabled_providers = lib.mkDefault [
            "github-copilot"
          ];

          agent = {
            # primary agents
            # built-in
            build = {
              mode = "all";
              model = lib.mkDefault "github-copilot/gpt-5.3-codex";
              temperature = 0.2;
            };
            plan = {
              mode = "all";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
              effort = "high";
              thinking = {
                type = "adaptive";
              };
            };

            # custom
            orchestrator = {
              mode = "primary";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
              effort = "low";
              thinking = {
                type = "adaptive";
              };
              permission = {
                "*" = "deny";
                question = "allow";
                todoread = "allow";
                todowrite = "allow";
                task = {
                  "*" = "allow";
                };
              };
            };

            rubber-duck = {
              mode = "all";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
              effort = "low";
              thinking = {
                type = "adaptive";
              };
              permission = {
                "*" = "deny";
                write = "deny";
                read = "ask";
                webfetch = "allow";
                websearch = "allow";
                question = "allow";
                task = {
                  "*" = "allow";
                };
              };
            };

            deep-thinker = {
              mode = "all";
              model = lib.mkDefault "github-copilot/claude-opus-4.7";
              effort = "high";
              thinking = {
                type = "adaptive";
              };
              permission = {
                "*" = "deny";
                write = "deny";
                read = "ask";
                webfetch = "allow";
                websearch = "allow";
                question = "allow";
                task = {
                  "*" = "allow";
                };
              };
            };

            # sub-agents
            # built-in
            explore = {
              model = lib.mkDefault "github-copilot/claude-haiku-4.5";
              temperature = 0.1;
              textVerbosity = "low";
            };
            general = {
              model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
              thinking = {
                type = "adaptive";
              };
              effort = "medium";
            };

            debugger = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
              effort = "high";
              thinking = {
                type = "adaptive";
              };
              permission = {
                bash = "ask";
                edit = "ask";
              };
            };
            writer = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/gpt-4.1";
              temperature = 0.7;
              textVerbosity = "high";
            };
            reviewer = {
              mode = "subagent";
              model = lib.mkDefault "github-copilot/claude-opus-4.7";
              effort = "high";
              thinking = {
                type = "adaptive";
              };
              permission = {
                write = "deny";
                read = "allow";
                question = "allow";
              };
            };
          };

        };
      };
    };
  };
}
