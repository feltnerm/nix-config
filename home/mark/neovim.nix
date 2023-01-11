{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc;

  vimPlugins = with pkgs; [
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
    vim-nix
    vim-devicons # load last
  ];
in {
  config = {
    feltnerm = {
      neovim = {
        enable = true;
      };
    };

    programs.neovim = {
      coc = {
        enable = true;
      };
      extraPackages = [pkgs.deno];
      extraConfig = feltnermVimrc;
      plugins = vimPlugins;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
