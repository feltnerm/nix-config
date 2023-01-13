{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;
  nvimLspConfig = builtins.readFile ./nvim-lsp.config.lua;

  languageServers = with pkgs; [
    efm-langserver
    gopls
    jdt-language-server
    kotlin-language-server
    nil
    nodePackages.bash-language-server
    pyright
    rust-analyzer
  ];

  vimPlugins = with pkgs.vimPlugins; [
    nvim-jdtls # java language server
    rust-tools-nvim # rust tools

    # syntaxes
    kotlin-vim
    rust-vim
    vim-markdown
    vim-nix
    vim-toml

    playground

    # lsp
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = nvimLspConfig;
    }

    # cmp
    cmp-buffer
    cmp-nvim-tags
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp-signature-help
    cmp-nvim-lsp
    cmp-git
    cmp-path
    lspkind-nvim
    {
      plugin = nvim-cmp;
      type = "lua";
      config = ''
        local cmp = require('cmp')

        cmp.setup{
          formatting = { format = require('lspkind').cmp_format() },
          -- Same keybinds as vim's vanilla completion
          mapping = cmp.mapping.preset.insert({
            ['<C-j>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ['<C-k>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name='nvim_lsp' },
            { name='nvim_lsp_document_symbol' },
            { name='nvim_lsp_signature_help' },
            { name='buffer', option = { get_bufnrs = vim.api.nvim_list_bufs } },
          }),
        }

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'cmp_git' },
          }, {
            { name = 'buffer' },
          })
        })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })

        -- Set up lspconfig.
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
      '';
    }

    # treesitter
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = ''
        lua <<EOF
          require('nvim-treesitter.configs').setup {
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
      type = "lua";
      config = ''
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
      '';
    }

    # telescope
    {
      plugin = telescope-nvim;
      type = "lua";
      config = ''
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
      '';
    }
    {
      plugin = telescope-file-browser-nvim;
      type = "lua";
      config = ''
        require("telescope").load_extension "file_browser"
        vim.keymap.set("n", "<leader>pd", require "telescope".extensions.file_browser.file_browser, {})
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
    {
      # TODO https://github.com/folke/which-key.nvim/#-setup
      plugin = which-key-nvim;
      type = "lua";
      config = ''
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup({
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        })
      '';
    }
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
      extraPackages =
        [
          pkgs.universal-ctags
          pkgs.ripgrep
          pkgs.tree-sitter
          # pkgs.tree-sitter-grammars

          # pkgs.deno
          # pkgs.nodejs

          # pkgs.shellcheck
        ]
        ++ languageServers;
      extraConfig = feltnermVimrc;
      plugins = vimPlugins;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
