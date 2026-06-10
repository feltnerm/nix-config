{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.developer.ai;

  providerProfiles = {
    openai = {
      model = "openai/gpt-5.4";
      small_model = "openai/gpt-5.4-mini-fast";
      agents = {
        build = {
          model = "openai/gpt-5.4-mini";
          variant = "medium";
        };
        plan = {
          model = "openai/gpt-5.4";
          variant = "high";
        };
        orchestrator = {
          model = "openai/gpt-5.4-mini";
          variant = "low";
        };
        "rubber-duck" = {
          model = "openai/gpt-5.4-mini";
          variant = "low";
        };
        "deep-thinker" = {
          model = "openai/gpt-5.4";
          variant = "high";
        };
        explore = {
          model = "openai/gpt-5.4-mini-fast";
          variant = "low";
        };
        general = {
          model = "openai/gpt-5.4";
          variant = "medium";
        };
        debugger = {
          model = "openai/gpt-5.4";
          variant = "high";
        };
        writer = {
          model = "openai/gpt-5.4-mini-fast";
          variant = "low";
        };
        reviewer = {
          model = "openai/gpt-5.5";
          variant = "high";
        };
      };
    };

    "github-copilot" = {
      model = "github-copilot/claude-sonnet-4.6";
      small_model = "github-copilot/gpt-4o-mini";
      agents = {
        build = {
          model = "github-copilot/gpt-5.3-codex";
          variant = "high";
        };
        plan = {
          model = "github-copilot/claude-sonnet-4.6";
          variant = "high";
        };
        orchestrator = {
          model = "github-copilot/claude-sonnet-4.6";
          variant = "low";
        };
        "rubber-duck" = {
          model = "github-copilot/gpt-4o-mini";
          variant = "low";
        };
        "deep-thinker" = {
          model = "github-copilot/claude-opus-4.7";
          variant = "high";
        };
        explore = {
          model = "github-copilot/gpt-4o-mini";
          variant = "low";
        };
        general = {
          model = "github-copilot/claude-sonnet-4.6";
        };
        debugger = {
          model = "github-copilot/claude-sonnet-4.6";
          variant = "high";
        };
        writer = {
          model = "github-copilot/gpt-4.1";
          variant = "low";
        };
        reviewer = {
          model = "github-copilot/claude-opus-4.7";
          variant = "high";
        };
      };
    };
  };

  profile = if cfg.provider.name != null then providerProfiles.${cfg.provider.name} or { } else { };
in
{
  config = lib.mkIf cfg.enable {

    feltnerm.developer.ai.agents = lib.mapAttrs (_: lib.mapAttrs (_: lib.mkDefault)) (
      profile.agents or { }
    );

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
      llama-cpp
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

          enabled_providers = lib.mkDefault (
            lib.unique (
              lib.optional (cfg.provider.name != null) cfg.provider.name ++ lib.attrNames cfg.providers
            )
          );

          provider = lib.mkMerge [
            (lib.mkDefault (
              lib.optionalAttrs (cfg.provider.name != null) {
                ${cfg.provider.name} = cfg.provider.settings;
              }
            ))
            (lib.mapAttrs (_: p: p.settings) cfg.providers)
          ];

          plugin = lib.mkDefault (lib.unique (lib.concatMap (p: p.plugins) (lib.attrValues cfg.providers)));

          agent = {
            # primary agents
            # built-in
            build = lib.filterAttrs (_: v: v != null) {
              mode = "all";
              temperature = 0.2;
              model = cfg.agents.build.model;
              variant = cfg.agents.build.variant;
            };

            plan = lib.filterAttrs (_: v: v != null) {
              mode = "all";
              model = cfg.agents.plan.model;
              variant = cfg.agents.plan.variant;
            };

            # custom
            orchestrator = lib.filterAttrs (_: v: v != null) {
              mode = "primary";
              model = cfg.agents.orchestrator.model;
              variant = cfg.agents.orchestrator.variant;
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

            rubber-duck = lib.filterAttrs (_: v: v != null) {
              mode = "all";
              model = cfg.agents."rubber-duck".model;
              variant = cfg.agents."rubber-duck".variant;
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

            deep-thinker = lib.filterAttrs (_: v: v != null) {
              mode = "all";
              model = cfg.agents."deep-thinker".model;
              variant = cfg.agents."deep-thinker".variant;
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
            explore = lib.filterAttrs (_: v: v != null) {
              temperature = 0.1;
              textVerbosity = "low";
              model = cfg.agents.explore.model;
              variant = cfg.agents.explore.variant;
            };

            general = lib.filterAttrs (_: v: v != null) {
              model = cfg.agents.general.model;
              variant = cfg.agents.general.variant;
            };

            debugger = lib.filterAttrs (_: v: v != null) {
              mode = "subagent";
              model = cfg.agents.debugger.model;
              variant = cfg.agents.debugger.variant;
              permission = {
                bash = "ask";
                edit = "ask";
              };
            };

            writer = lib.filterAttrs (_: v: v != null) {
              mode = "subagent";
              temperature = 0.7;
              textVerbosity = "high";
              model = cfg.agents.writer.model;
              variant = cfg.agents.writer.variant;
            };

            reviewer = lib.filterAttrs (_: v: v != null) {
              mode = "subagent";
              model = cfg.agents.reviewer.model;
              variant = cfg.agents.reviewer.variant;
              permission = {
                write = "deny";
                read = "allow";
                question = "allow";
              };
            };
          };

        }
        // lib.optionalAttrs (profile ? model) { model = lib.mkDefault profile.model; }
        // lib.optionalAttrs (profile ? small_model) {
          small_model = lib.mkDefault profile.small_model;
        };
      };
    };
  };
}
