{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.ui;

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
  options.feltnerm.programs.neovim.ui = {
    enable = lib.mkOption {
      description = "Enable neovim UI.";
      default = false;
    };

    startify = {
      enable = lib.mkOption {
        description = "Enable neovim startify.";
        default = false;
      };

      # TODO reference `${pkgs.chuckscii}/bin` or something
      extraConfig = lib.mkOption {
        description = "Edit the startify header.";
        default = ''
          let g:startify_header = system('chuckscii')
          let g:startify_custom_header =
            \ startify#center(split(startify_header, '\n')) +
            \ startify#center([""]) +
            \ startify#center(startify#fortune#boxed()) +
            \ startify#center([""]) +
            \ startify#center(split(system('date -R'), '\n')) +
            \ startify#center([""]) +
            \ startify#center(split(system('year-progress 100'), '\n'))
        '';
      };
    };
  };

  config = {
    programs.neovim.plugins = lib.mkIf cfg.enable (uiPlugins
      ++ (
        if cfg.startify.enable
        then [
          {
            plugin = pkgs.vimPlugins.vim-startify;
            #type = "lua";
            config = ''
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

                  ${cfg.startify.extraConfig}
            '';
          }
        ]
        else []
      ));
  };
}
