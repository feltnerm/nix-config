{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;

  # TODO

  vimPlugins = with pkgs.vimPlugins; [
    playground
    git-blame-nvim
    {
      plugin = nvim-autopairs;
      type = "lua";
      config = ''
        require("nvim-autopairs").setup {}
      '';
    }
    {
      plugin = auto-save-nvim;
      type = "lua";
      config = ''
        require("auto-save").setup {}
      '';
    }
    {
      plugin = indent-blankline-nvim;
      type = "lua";
      config = ''
        local indentBlankline = require("indent_blankline")
        indentBlankline.setup({
            -- for example, context is off by default, use this to turn it on
            show_current_context = true,
            show_current_context_start = true,
        })
      '';
    }
    {
      plugin = vim-startify;
      #type = "lua";
      config = ''
           ""let g:startify_header = system('figlet -w 100 -f colossal vim')
           let g:startify_header = system('chuckscii')
           let g:startify_custom_header =
             \ startify#center(split(startify_header, '\n')) +
             \ startify#center([""]) +
             \ startify#center(startify#fortune#boxed()) +
             \ startify#center([""]) +
             \ startify#center(split(system('date -R'), '\n')) +
             \ startify#center([""]) +
             \ startify#center(split(system('year-progress 100'), '\n'))


          function! s:gitModified()
            let files = systemlist('git ls-files -m 2>/dev/null')
            return map(files, "{'line': v:val, 'path': v:val}")
        endfunction

          " same as above, but show untracked files, honouring .gitignore
          function! s:gitUntracked()
              let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
              return map(files, "{'line': v:val, 'path': v:val}")
          endfunction

          let g:startify_lists = [
                  \ { 'type': 'files',     'header': ['   MRU']            },
                  \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
                  \ { 'type': 'sessions',  'header': ['   Sessions']       },
                  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
                  \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
                  \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
                  \ { 'type': 'commands',  'header': ['   Commands']       },
                  \ ]
      '';
    }
    #{
    #  plugin = alpha-nvim;
    #  type = "lua";
    #  config = builtins.readFile ./alpha.lua;
    #}
    # FIXME
    #{
    #  plugin = hop-nvim;
    #  type = "lua";
    #  config = builtins.readFile ./hop.lua;
    #}
    #{
    #  plugin = auto-session;
    #  type = "lua";
    #  config = ''
    #    require("auto-session").setup {
    #      log_level = "error",
    #      auto_session_suppress_dirs = { "~/", "~/code", "~/Downloads", "/"},
    #      auto_session_enabled = true,
    #      auto_session_create_enabled = true,
    #      auto_save_enabled = true,
    #      auto_restored_enabled = false,
    #      auto_session_use_git_branch = true,

    #      cwd_change_handling = {
    #        restore_upcoming_session = false,

    #        pre_cwd_changed_hook = nil,
    #        -- post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
    #        --   require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
    #        -- end,
    #      },
    #    }
    #  '';
    #}
    {
      plugin = nerdtree;
      config = ''
        nmap <leader>d :NERDTreeToggle<CR>
        nmap <leader>de :NERDTreeToggleVCS<CR>
        nmap <leader>df :NERDTreeFind<CR>
      '';
    }
    {
      # TODO https://github.com/folke/which-key.nvim/#-setup
      plugin = which-key-nvim;
      type = "lua";
      config = ''
        vim.o.timeout = true
        vim.o.timeoutlen = 300
        require("which-key").setup({})
      '';
    }
  ];
in {
  imports = [./cmp.nix ./lsp.nix ./telescope.nix ./treesitter.nix ./ui.nix ./vimwiki.nix];

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

        # pkgs.tree-sitter-grammars
        # pkgs.deno
        # pkgs.nodejs
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
