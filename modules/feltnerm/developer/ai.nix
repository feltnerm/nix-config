_: {
  config.den.aspects.features.provides.developer-ai = {
    homeManager =
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
        imports = [
          ../home/base.nix
          ../home/nixvim.nix
        ];

        config = lib.mkIf cfg.enable {
          home.shellAliases.nvimz = ''nvim -c "lua vim.defer_fn(function() vim.cmd('CodeCompanionChat Toggle') end, 100)"'';

          programs.git = lib.mkIf config.programs.git.enable {
            ignores = [
              ".opencode"
              ".aider"
            ];
          };

          home.packages = with pkgs; [
            spec-kit
          ];

          services = {
            ollama = {
              enable = lib.mkDefault true;
            };
          };

          programs = {
            gemini-cli = {
              enable = lib.mkDefault true;
            };
            opencode = {
              enable = lib.mkDefault true;
              agents = { };
              settings = {
                agent = {
                  build = {
                    model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
                    reasoningEffort = lib.mkDefault "medium";
                    textVerbosity = lib.mkDefault "low";
                  };
                  plan = {
                    model = lib.mkDefault "github-copilot/gpt-5.2";
                    reasoningEffort = lib.mkDefault "high";
                    textVerbosity = lib.mkDefault "low";
                  };
                  explore = {
                    model = lib.mkDefault "github-copilot/gpt-4o";
                  };
                  general = {
                    model = lib.mkDefault "github-copilot/gpt-5";
                  };
                };
              };
            };
          };

          programs.nixvim = {
            keymaps = [
              {
                key = "<leader>at";
                action = "<cmd>CodeCompanionChat Toggle<cr>";
                options = {
                  desc = "codecompanion chat toggle";
                };
              }
              {
                key = "<leader>ai";
                mode = [
                  "n"
                  "v"
                ];
                action = "<cmd>CodeCompanion<cr>";
                options = {
                  desc = "codecompanion inline";
                };
              }
              {
                key = "<leader>aa";
                mode = [
                  "n"
                  "v"
                ];
                action = "<cmd>CodeCompanionActions<cr>";
                options = {
                  desc = "codecompanion actions";
                };
              }
              {
                key = "<leader>al";
                action = "<cmd>CodeCompanionCLI<cr>";
                options = {
                  desc = "codecompanion cli";
                };
              }
              {
                key = "<leader>aL";
                action = "<cmd>CodeCompanionCLI!<cr>";
                options = {
                  desc = "codecompanion cli (submit)";
                };
              }
              {
                key = "<leader>ax";
                mode = "v";
                action = "<cmd>CodeCompanionChat Add<cr>";
                options = {
                  desc = "codecompanion add to chat";
                };
              }
              {
                key = "<leader>oa";
                mode = [
                  "n"
                  "x"
                ];
                action = "<cmd>lua require('opencode').ask('@this: ', { submit = true })<cr>";
                options = {
                  desc = "opencode ask";
                };
              }
              {
                key = "<leader>ox";
                mode = [
                  "n"
                  "x"
                ];
                action = "<cmd>lua require('opencode').select()<cr>";
                options = {
                  desc = "opencode select action";
                };
              }
              {
                key = "<leader>ot";
                mode = "n";
                action = "<cmd>lua require('opencode').toggle()<cr>";
                options = {
                  desc = "opencode toggle";
                };
              }
              {
                key = "<leader>or";
                mode = [
                  "n"
                  "x"
                ];
                action = "v:lua.require'opencode'.operator('@this ')";
                options = {
                  desc = "opencode add range";
                  expr = true;
                };
              }
              {
                key = "<leader>ol";
                mode = "n";
                action = "v:lua.require'opencode'.operator('@this ') .. '_'";
                options = {
                  desc = "opencode add line";
                  expr = true;
                };
              }
              {
                key = "<leader>oU";
                mode = "n";
                action = "<cmd>lua require('opencode').command('session.half.page.up')<cr>";
                options = {
                  desc = "opencode scroll up";
                };
              }
              {
                key = "<leader>oD";
                mode = "n";
                action = "<cmd>lua require('opencode').command('session.half.page.down')<cr>";
                options = {
                  desc = "opencode scroll down";
                };
              }
            ];

            plugins = {
              codecompanion = {
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

              which-key = {
                settings.spec = lib.mkAfter [
                  {
                    __unkeyed-1 = "<leader>a";
                    group = "CodeCompanion";
                    icon = "󰡣 ";
                  }
                  {
                    __unkeyed-1 = "<leader>o";
                    group = "OpenCode";
                    icon = "󰚩 ";
                  }
                ];
              };

              opencode = {
                enable = lib.mkDefault true;
                agents = { };
                settings = {
                  agent = {
                    build = {
                      model = lib.mkDefault "github-copilot/claude-sonnet-4.6";
                      reasoningEffort = lib.mkDefault "medium";
                      textVerbosity = lib.mkDefault "low";
                    };
                    plan = {
                      model = lib.mkDefault "github-copilot/gpt-5.2";
                      reasoningEffort = lib.mkDefault "high";
                      textVerbosity = lib.mkDefault "low";
                    };
                    explore = {
                      model = lib.mkDefault "github-copilot/gpt-4o";
                    };
                    general = {
                      model = lib.mkDefault "github-copilot/gpt-5";
                    };
                  };
                };
              };

              copilot-lua = lib.mkIf (cfg.provider == "copilot") {
                enable = lib.mkDefault true;
                settings = {
                  suggestion = {
                    enabled = false;
                  };
                  panel = {
                    enabled = false;
                  };
                };
              };

              blink-copilot.enable = lib.mkDefault (cfg.provider == "copilot");
              blink-cmp = {
                settings = {
                  sources = {
                    default = lib.mkForce [
                      "lsp"
                      "snippets"
                      "path"
                      cfg.provider
                      "buffer"
                    ];
                    providers = {
                      copilot = lib.mkIf (cfg.provider == "copilot") {
                        enabled = lib.mkDefault cfg.enable;
                        name = "copilot";
                        module = "blink-copilot";
                        async = true;
                        score_offset = -100;
                      };
                    };
                  };
                };
              };
            };
          };
        };
      };
  };
}
