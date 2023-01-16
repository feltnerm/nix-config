{pkgs, ...}: let
  uiPlugins = with pkgs.vimPlugins; [
    {
      plugin = base16-vim;
      config = ''
        let base16colorspace=256
      '';
    }
    vim-colorschemes
    vim-janah
    gruvbox-material
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
        let g:airline_theme = 'base16_gruvbox_dark_soft'
        let g:airline#extensions#tmuxline#enabled = 0
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
        let g:airline#extensions#branch#enabled = 1
        let g:airline#extensions#hunks#enabled = 1
      '';
    }
    vim-airline-themes
    vim-airline-clock
    vista-vim
    vim-devicons # load last
  ];
in {
  config = {
    programs.neovim.plugins = uiPlugins;
  };
}
