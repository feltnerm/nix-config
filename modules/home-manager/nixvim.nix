{
  pkgs,
  lib,
  ...
}:
{
  programs.nixvim = {
    defaultEditor = lib.mkDefault true;
    vimdiffAlias = lib.mkDefault true;
    #colorschemes.base16 = {
    #  enable = lib.mkDefault true;
    #  colorscheme = lib.mkDefault config.feltnerm.theme;
    #};

    globals = {
      mapleader = lib.mkDefault " ";
      maplocalleader = lib.mkDefault " ";
    };

    opts = {
      fileencoding = "utf-8";

      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];

      modeline = true;
      magic = true;
      autoindent = true;
      autoread = true;
      incsearch = true;
      smartcase = true;
      ignorecase = true;

      list = true;
      listchars = {
        tab = "⇥ ";
        leadmultispace = "┊ ";
        trail = "␣";
        nbsp = "⍽";
      };
      # more = true;

      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;
      joinspaces = false;

      number = true;
      relativenumber = true;
      ruler = true;
      scrolloff = 8;
      sidescrolloff = 8;
      # showcmd = true;
      # cmdheight = 1;
      linebreak = true;
      breakindent = true;
      copyindent = true;
      preserveindent = true;
      # colorcolumn = "120";
      cursorline = true;
      signcolumn = "auto";
      termguicolors = true;
      title = true;
      ttyfast = true;
      lazyredraw = true;
      updatetime = 100;
      pumheight = 8;
      showmatch = true;
      matchtime = 1;
      showcmd = true;

      wrap = false;

      foldenable = true;
      foldlevelstart = 20;
      foldmethod = "indent";

      splitbelow = true;
      splitright = true;

      errorbells = false;
      visualbell = true;
      # t_vb = "";

      backup = false;
      writebackup = false;

      mouse = "a";
      mousehide = true;

      backspace = "eol,start,indent";
    };
    keymaps = [
      # {
      #   key = "<Space>";
      #   action = "<NOP>";
      # }
      # {
      #     key = "qq";
      #     action = "<NOP>";
      #     options = {
      #         desc = "disable recording when I spaz out";
      #     };
      # }
      {
        key = "<esc>";
        action = "<cmd>noh<CR>";
        options = {
          desc = "clear search highlights";
        };
      }
      {
        key = "<leader>/";
        action = "<cmd>noh<CR>";
        options = {
          desc = "clear search highlights";
        };
      }
      {
        key = "<leader>VR";
        action = "<cmd>source $MYVIMRC<CR>";
        options = {
          desc = "reload $MYVIMRC";
        };
      }
      {
        key = "B";
        action = "^";
        options = {
          desc = "go to beginning of line";
        };
      }
      {
        key = "E";
        action = "$";
        options = {
          desc = "go to end of line";
        };
      }
      {
        key = "<leader><Tab>";
        action = "<cmd>tabnext<CR>";
        options = {
          desc = "go to next tab";
        };
      }
      {
        key = "<leader><S-Tab>";
        action = "<cmd>tabprev<CR>";
        options = {
          desc = "go to previous tab";
        };
      }
      {
        key = "<leader>tn";
        action = "<cmd>tabnew<CR>";
        options = {
          desc = "create a new tab";
        };
      }
      {
        key = "<leader>tc";
        action = "<cmd>tabclose<CR>";
        options = {
          desc = "close the current tab";
        };
      }
      {
        key = "<leader>sw";
        action = "<cmd>split<CR>";
        options = {
          desc = "split horizontal";
        };
      }
      {
        key = "<leader>sv";
        action = "<cmd>vsplit<CR>";
        options = {
          desc = "split vertical";
        };
      }
      {
        key = "<leader>wh";
        action = "<C-w>h";
        options = {
          desc = "move split left";
        };
      }
      {
        key = "<leader>wj";
        action = "<C-w>j";
        options = {
          desc = "move split down";
        };
      }
      {
        key = "<leader>wk";
        action = "<C-w>k";
        options = {
          desc = "move split right";
        };
      }
      {
        key = "<leader>wl";
        action = "<C-w>l";
        options = {
          desc = "move split up";
        };
      }
      {
        key = "jj";
        mode = "i";
        action = "<Esc>";
        options = {
          desc = "";
        };
      }
      {
        key = "jk";
        mode = "i";
        action = "<Esc>";
        options = {
          desc = "";
        };
      }

      {
        key = "<Esc>";
        mode = "v";
        action = "<C-c>";
        options = {
          desc = "";
        };
      }
      {
        key = "<";
        mode = "v";
        action = "<gv";
        options = {
          desc = "tab left";
        };
      }
      {
        key = ">";
        mode = "v";
        action = ">gv";
        options = {
          desc = "tab right";
        };
      }
      {
        key = "<F1>";
        action = "<Esc>";
        options = {
          desc = "no help";
        };
      }
    ];
    plugins = {
      direnv.enable = lib.mkDefault true;
      commentary.enable = lib.mkDefault true;
      nvim-surround.enable = lib.mkDefault true;
      auto-save.enable = lib.mkDefault true;
      repeat.enable = lib.mkDefault true;
      which-key.enable = lib.mkDefault true;
      yanky.enable = lib.mkDefault true;
      hop.enable = lib.mkDefault true;
      wrapping.enable = lib.mkDefault true;

      # git
      fugitive.enable = lib.mkDefault true;
      gitblame.enable = lib.mkDefault true;
      gitgutter.enable = lib.mkDefault true;

      # ui
      lualine.enable = lib.mkDefault true;
      luasnip.enable = lib.mkDefault true;
      neo-tree.enable = lib.mkDefault true;
      web-devicons.enable = lib.mkDefault true;
      todo-comments.enable = lib.mkDefault true;

      blink-cmp = {
        enable = lib.mkDefault true;
        settings = {
          keymap.preset = lib.mkDefault "super-tab";
          signature.enabled = lib.mkDefault true;
          completion = {
            documentation.auto_show = lib.mkDefault true;
            accept.auto_brackets = {
              enabled = lib.mkDefault true;
              semantic_token_resolution.enabled = lib.mkDefault true;
            };
          };
        };
      };

      lsp = {
        enable = lib.mkDefault true;
        keymaps = {
          diagnostic = {
            "<leader>ce" = "open_float";
            "<leader>j" = "goto_next";
            "<leader>k" = "goto_prev";
            "<leader>q" = "setloclist";
          };
          lspBuf = {
            K = "hover";
            gD = "references";
            #gD = "declaration";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
            n = "signature_help";
            f = "format";

            ca = "code_action";
            cr = "rename";
          };
          extra = [
            {
              action = "<cmd>LspStop<Enter>";
              key = "<leader>lx";
              options = {
                desc = "stop the lsp";
              };
            }
            {
              action = "<cmd>LspStart<Enter>";
              key = "<leader>ls";
              options = {
                desc = "start the lsp";
              };
            }
            {
              action = "<cmd>LspRestart<Enter>";
              key = "<leader>lr";
              options = {
                desc = "restart the lsp";
              };
            }
          ];
        };
      };

      telescope = {
        enable = lib.mkDefault true;
        keymaps = {
          "<leader>p" = "live_grep";
          "<leader>pp" = "current_buffer_fuzzy_find";
          "<leader>pf" = "find_files";
          "<leader>pb" = "buffers";
          "<leader>n" = "tags";
          "<leader>pbt" = "current_buffer_tags";
          "<leader>phc" = "command_history";
          "<leader>phs" = "search_history";
          "<leader>phh" = "help_tags";
          "<leader>pq" = "quickfix";

          # git
          "<leader>pg" = "git_files";
          "<leader>pgc" = "git_commits";
          "<leader>pgbc" = "git_bcommits";
          "<leader>pgs" = "git_status";
          "<leader>pgb" = "git_branches";
          "<leader>ctt" = "treesitter";

          # lsp
          "<leader>cr" = "lsp_references";
          "<leader>cci" = "lsp_incoming_calls";
          "<leader>cco" = "lsp_outgoing_calls";
          "<leader>cs" = "lsp_document_symbols";
          "<leader>cws" = "lsp_workspace_symbols";
          "<leader>ci" = "lsp_implementations";
          "<leader>cd" = "lsp_definitions";
          "<leader>ct" = "lsp_type_definitions";
        };
      };

      conform-nvim = {
        enable = lib.mkDefault true;
        settings = {
          formatters = {
            squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
          };
          formatters_by_ft = {
            "_" = [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
          };
        };
      };

      markview.enable = lib.mkDefault true;

      # treesitter
      treesitter-context = {
        enable = lib.mkDefault true;
        settings = {
          max_lines = 2;
        };
      };
      treesitter = {
        enable = lib.mkDefault true;
        settings = {
          highlight.enable = true;
          incremental_selection.enable = true;
          indent.enable = true;
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };
      # autoCmd = [
      # # Remove trailing whitespace on save
      # (lib.mkIf (!lib.elem "trim_whitespace" config.plugins.conform-nvim.settings.formatters_by_ft."_") {
      #   event = "BufWrite";
      #   command = "%s/\\s\\+$//e";
      # })
      # ];
      # plugins = {
    };
  };
}
