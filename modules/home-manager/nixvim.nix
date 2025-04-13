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
      mapleader = lib.mkDefault " "; # FIXME: use keycode <space>?
      maplocalleader = lib.mkDefault " "; # FIXME: control or space?
      netrw_banner = 0;
    };

    opts = {
      fileencoding = "utf-8";

      completeopt = [
        "menu"
        "menuone"
        "noselect"
      ];

      autoread = true;
      modeline = true;
      showcmd = true;
      cmdheight = 1;

      wrap = false;

      list = true;
      listchars = {
        tab = "⇥ ";
        leadmultispace = "┊ ";
        trail = "␣";
        nbsp = "⍽";
      };
      # more = true;

      expandtab = true;
      joinspaces = false;
      shiftwidth = 2;
      softtabstop = 2;
      tabstop = 2;

      autoindent = true;
      breakindent = true;
      copyindent = true;
      linebreak = true;
      preserveindent = true;

      cursorline = true;
      number = true;
      relativenumber = true;
      ruler = true;
      signcolumn = "auto";

      scrolloff = 8;
      sidescrolloff = 8;

      colorcolumn = "80";
      lazyredraw = true;
      pumheight = 8;
      termguicolors = true;
      title = true;
      ttyfast = true;
      updatetime = 100;

      foldenable = true;
      foldlevelstart = 99;
      foldmethod = "indent";

      ignorecase = true;
      incsearch = true;
      magic = true;
      matchtime = 1;
      showmatch = true;
      smartcase = true;

      splitbelow = true;
      splitright = true;

      errorbells = false;
      visualbell = true;
      # t_vb = "";

      backup = false;
      confirm = true;
      writebackup = false;
      undofile = true;
      undolevels = 10000;

      backspace = "eol,start,indent";
      mouse = "a";
      mousehide = true;

      # TODO: figure out syntax for
      # vim.opt.diffopt:append("linematch:60") -- second stage diff to align lines
    };
    keymaps = [
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
      {
        key = "<leader>d";
        action = "<CMD>Neotree toggle<CR>";
        options = {
          desc = "toggle neotree";
        };
      }
    ];
    plugins = {
      lz-n.enable = lib.mkForce true; # required for lazy loading

      auto-save.enable = lib.mkDefault true;
      commentary.enable = lib.mkDefault true;
      nvim-surround.enable = lib.mkDefault true;
      repeat.enable = lib.mkDefault true;
      wrapping.enable = lib.mkDefault true;
      yanky.enable = lib.mkDefault true;

      # ui
      lualine.enable = lib.mkDefault true;
      todo-comments.enable = lib.mkDefault true;
      web-devicons.enable = lib.mkDefault true;

      markview = {
        enable = lib.mkDefault true;
        lazyLoad.settings.ft = "markdown";
      };

      neo-tree = {
        enable = lib.mkDefault true;
        filesystem.followCurrentFile.enabled = lib.mkDefault true;
      };
      # oil.enable = lib.mkDefault true;

      blink-cmp = {
        enable = lib.mkDefault true;
        settings = {
          keymap.preset = lib.mkDefault "enter";
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

      telescope = {
        enable = lib.mkDefault true;
        keymaps = {
          # grep
          "<leader>p" = {
            action = "live_grep";
            options = {
              desc = "telecope find in file";
            };
          };
          "<leader>pp" = {
            action = "current_buffer_fuzzy_find";
            options = {
              desc = "telecope find in buffer";
            };
          };

          # files
          "<leader>f" = {
            action = "find_files";
            options = {
              desc = "telecope find file";
            };
          };

          # buffers
          "<leader>b" = {
            action = "find buffer";
            options = {
              desc = "telecope find buffer";
            };
          };
          "<leader>bt" = {
            action = "current_buffer_tags";
            options = {
              desc = "telecope find buffer tag";
            };
          };

          # git
          "<leader>g" = {
            action = "git_files";
            options = {
              desc = "telecope find git file";
            };
          };
          "<leader>gc" = {
            action = "git_commits";
            options = {
              desc = "telecope find git commit";
            };
          };
          "<leader>gbc" = {
            action = "git_bcommits";
            options = {
              desc = "telecope find git bcommits";
            };
          };
          "<leader>gb" = {
            action = "git_branches";
            options = {
              desc = "telecope find git branches";
            };
          };
          "<leader>gs" = {
            action = "git_status";
            options = {
              desc = "telecope find git status";
            };
          };
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

      which-key = {
        enable = lib.mkDefault true;
        settings = {
          replace = {
            desc = [
              [
                "<space>"
                "SPACE"
              ]
              [
                "<leader>"
                "SPACE"
              ]
              [
                "<[cC][rR]>"
                "RETURN"
              ]
              [
                "<[tT][aA][bB]>"
                "TAB"
              ]
              [
                "<[bB][sS]>"
                "BACKSPACE"
              ]
            ];
          };
          win = {
            border = "single";
          };
        };
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
