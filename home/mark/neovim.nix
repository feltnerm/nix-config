{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;
  nvimLspConfig = builtins.readFile ./nvim-lsp.config.lua;

  vimPlugins = with pkgs.vimPlugins; [
    {
      plugin = nvim-lspconfig;
      config = ''
        lua <<EOF
          ${nvimLspConfig}
        EOF
      '';
    }
    {
      # plugin = nvim-treesitter;
      plugin = nvim-treesitter.withPlugins (plugin:
        with plugin; [
          bash
          help
          html
          http
          jq
          json
          lua
          markdown
          markdown_inline
          nix
          regex
          sql
          toml
          vim
          yaml
        ]);
      config = ''
        lua <<EOF
          require'nvim-treesitter.configs'.setup {
            -- let nix handle the install
            auto_install = false,

            highlight = {
              enable = true,
              additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "gnn", -- set to `false` to disable one of the mappings
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
              },
            },
            indent = {
              enable = true
            },
          }
        EOF
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable                     " Disable folding at startup.
      '';
    }
    {
      plugin = nvim-treesitter-refactor;
      config = ''
        lua <<EOF
          require'nvim-treesitter.configs'.setup {
            refactor = {
              highlight_definitions = {
                enable = true,
                -- Set to false if you have an `updatetime` of ~100.
                clear_on_cursor_move = true,
              },
              highlight_current_scope = { enable = true },
              smart_rename = {
                enable = true,
                keymaps = {
                  smart_rename = "grr",
                },
              },
              navigation = {
                enable = true,
                keymaps = {
                  goto_definition = "gnd",
                  list_definitions = "gnD",
                  list_definitions_toc = "gO",
                  goto_next_usage = "<a-*>",
                  goto_previous_usage = "<a-#>",
                },
              },
            },
          }
        EOF
      '';
    }
    {
      plugin = telescope-nvim;
      config = ''
        lua <<EOF
          require('telescope').setup{
            pickers = {
              buffers = { theme = "dropdown", },
              find_files = { theme = "dropdown", },
              git_branches = { theme = "dropdown", },
              git_files = { theme = "dropdown", },
              help_tags = { theme = "dropdown", },
              help_tags = { theme = "dropdown", },
              live_grep = { theme = "dropdown" },

              current_buffer_fuzzy_find = { theme = "cursor" },
              current_buffer_tags = { theme = "cursor" },
              quickfix = { theme = "cursor" },

              command_history = { theme = "ivy" },
              search_history = { theme = "ivy" },
              help_tags = { theme = "ivy" },
            }
          }
          local builtin = require('telescope.builtin')

          vim.keymap.set('n', '<leader>p', builtin.live_grep, {})
          vim.keymap.set('n', '<leader>pp', builtin.current_buffer_fuzzy_find, {})
          vim.keymap.set('n', '<leader>pf', builtin.find_files, {})

          vim.keymap.set('n', '<leader>pb', builtin.buffers, {})

          vim.keymap.set('n', '<leader>pt', builtin.tags, {})
          vim.keymap.set('n', '<leader>pbt', builtin.current_buffer_tags, {})

          vim.keymap.set('n', '<leader>phc', builtin.command_history, {})
          vim.keymap.set('n', '<leader>phs', builtin.search_history, {})
          vim.keymap.set('n', '<leader>phh', builtin.help_tags, {})

          vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})

          vim.keymap.set('n', '<leader>pg', builtin.git_files, {})
          vim.keymap.set('n', '<leader>pgc', builtin.git_commits, {})
          vim.keymap.set('n', '<leader>pgbc', builtin.git_bcommits, {})
          vim.keymap.set('n', '<leader>pgs', builtin.git_status, {})
          vim.keymap.set('n', '<leader>pgb', builtin.git_branches, {})

          vim.keymap.set('n', '<leader>cr', builtin.lsp_references, {})
          vim.keymap.set('n', '<leader>cci', builtin.lsp_incoming_calls, {})
          vim.keymap.set('n', '<leader>cco', builtin.lsp_outgoing_calls, {})
          vim.keymap.set('n', '<leader>cs', builtin.lsp_document_symbols, {})
          vim.keymap.set('n', '<leader>cws', builtin.lsp_workspace_symbols, {})
          vim.keymap.set('n', '<leader>ci', builtin.lsp_implementations, {})
          vim.keymap.set('n', '<leader>cd', builtin.lsp_definitions, {})
          vim.keymap.set('n', '<leader>ct', builtin.lsp_type_definitions, {})
          vim.keymap.set('n', '<leader>ctt', builtin.treesitter, {})
        EOF
      '';
    }

    base16-vim
    vim-colorschemes
    vim-janah
    gruvbox
    {
      plugin = vim-one;
      config = ''
        let g:one_allow_italics = 1
      '';
    }
    {
      plugin = vim-airline;
      config = ''
        """" airline settings
        let g:airline_theme = 'gruvbox'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#branch#enabled = 1
        let g:airline#extensions#hunks#enabled = 1
      '';
    }
    vim-airline-themes
    {
      plugin = nerdtree;
      config = ''
        nmap <leader>d :NERDTreeToggle<CR>
        nmap <leader>de :NERDTreeToggleVCS<CR>
        nmap <leader>df :NERDTreeFind<CR>
      '';
    }
    vista-vim
    vim-nix
    # TODO get nerdfonts setup
    vim-devicons # load last
  ];
in {
  config = {
    feltnerm.programs = {
      neovim = {
        enable = true;
      };
    };

    programs.neovim = {
      extraPackages = [
        pkgs.universal-ctags
        pkgs.ripgrep
        pkgs.tree-sitter

        # pkgs.deno
        # pkgs.nodejs

        # pkgs.efm-langserver
        # pkgs.rnix-lsp

        # pkgs.shellcheck
      ];
      extraConfig = feltnermVimrc;
      plugins = vimPlugins;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
