{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;

  vimPlugins = with pkgs.vimPlugins; [
    playground
    alpha-nvim

    # TODO
    {
      plugin = hop-nvim;
      type = "lua";
      # map <Leader><Leader> <Plug>(easymotion-prefix)
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
  imports = [./cmp.nix ./lsp.nix ./telescope.nix ./treesitter.nix ./ui.nix];

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
