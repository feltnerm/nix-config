{pkgs, ...}: let
  uiPlugins = with pkgs.vimPlugins; [
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
    vista-vim
    vim-devicons # load last
  ];
in {
  config = {};
}
