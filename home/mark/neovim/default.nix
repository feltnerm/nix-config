{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;

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
      plugin = auto-session;
      type = "lua";
      config = ''
        require("auto-session").setup {
          log_level = "error",
          auto_session_suppress_dirs = { "~/", "~/code", "~/Downloads", "/"},

          cwd_change_handling = {
            -- defaults
            restore_upcoming_session = true,
            pre_cwd_changed_hook = nil,

            -- post_cwd_changed_hook = function() -- example refreshing the lualine status line _after_ the cwd changes
            --   require("lualine").refresh() -- refresh lualine so the new session name is displayed in the status bar
            -- end,
          },
        }
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
      plugin = alpha-nvim;
      type = "lua";
      config = ''
        local alpha = require("alpha")
        local theme = require("alpha.themes.dashboard")
        alpha.setup(theme.config)
      '';
    }

    {
      plugin = hop-nvim;
      type = "lua";
      config = builtins.readFile ./hop.lua;
    }
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
