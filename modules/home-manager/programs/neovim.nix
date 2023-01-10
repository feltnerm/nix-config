{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim;
  # TODO custom plugins
  # vim-workspace

  customVimPlugins = import ./neovim-plugins.nix {inherit pkgs lib;};
in {
  options.feltnerm.programs.neovim = {
    enable = lib.mkOption {
      description = "Enable neovim";
      default = false;
    };

    enableLanguageServer = lib.mkOption {
      description = "Enable language server";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # (neo)vim configuration
      #vim.enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
        withNodeJs = true;
        vimAlias = true;
        vimdiffAlias = true;

        # TODO enable language-server support
        coc = lib.mkIf cfg.enableLanguageServer {
          enable = true;
        };

        extraPackages = [pkgs.git pkgs.deno];

        extraConfig = ''
          map <space> <leader>

          lang en_US

          set modeline
          set magic
          set smartcase
          set autoindent
          set autoread
          set tabstop=4
          set shiftwidth=4
          set softtabstop=4
          set expandtab
          set nojoinspaces
          set termguicolors

          set list
          set more
          set number
          set numberwidth=5
          set relativenumber
          set ruler
          set scrolloff=1
          set showcmd
          set showmatch
          set sidescrolloff=1
          " splitting a window will put the new window below the current one
          set splitbelow
          "set t_Co=256
          set termguicolors
          set title
          set ttyfast
          set mat=2
          set lazyredraw
          set backspace=eol,start,indent
          set mouse=a
          set mousehide

          set foldenable
          set foldlevelstart=10
          set foldmethod=indent

          """" Backups
          set backupcopy=yes
          silent !mkdir -p $HOME/.vim/backup > /dev/null 2>&1
          set backupdir=$HOME/.vim/backup
          silent !mkdir -p $HOME/.vim/tmp > /dev/null 2>&1
          set directory=$HOME/.vim/tmp
          if has("persistent_undo")
              silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
              set undodir=~/.vim/undo
              if exists('+undofile')
                set undofile
              endif
          endif

          """" Bells/Sound
          set noerrorbells
          set novisualbell
          set visualbell
          set noerrorbells
          set t_vb=

          """" Diff
          " Add vertical spaces to keep right and left aligned
          set diffopt=filler
          " Ignore whitespace changes (focus on code changes)
          set diffopt+=iwhite
          set diffopt+=vertical

          set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case

          """" Vimrc editing
                 autocmd! bufwritepost .vimrc source %
                 " no trailing whitespace
                 autocmd BufWritePre * %s/\s\+$//e

          """" Appearance
          colorscheme base16-gruvbox-dark-soft
          set background=dark
          set cmdheight=1
          set colorcolumn=80
          set cursorline

          """ Keybindings
          noremap ; :
          inoremap jj <Esc>
          inoremap jk <Esc>
          vnoremap <ESC> <C-c>
          imap ii <C-[>
          " Disable accidental macro recording when I spaz out on the q key
          map qq <Nop>
          command! W w
          command! Q q


          cmap w!! w !sudo tee % >/dev/null
          " turn off search highlight
          nnoremap <leader>/ :nohlsearch<CR>
          " move to beginning/end of line
          nnoremap B ^
          nnoremap E $
          " Find merge conflict markers
          map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
          " highlight last inserted text
          nnoremap gV `[v`]
          vmap < <gv
          vmap > >gv
          " W" Ex mode: no ty
          map Q <Nop>

          """" Fuck help
          inoremap <F1> <ESC>
          nnoremap <F1> <ESC>
          vnoremap <F1> <ESC>

          """"  Tabs
          let notabs = 1
          noremap <leader><Tab> :tabnext<CR>
          noremap <leader><S-Tab> :tabprev<CR>
          noremap <leader>tn :tabnext<CR>
          noremap <leader>tp :tabprev<CR>
          noremap <leader>tw :tabnew<CR>
          noremap <leader>tc :tabclose<CR>

          """" Splits
          " Move between splits using hjkl
          map <C-h> <C-w>h
          map <C-j> <C-w>j
          map <C-k> <C-w>k
          map <C-l> <C-w>l
          " Create splits
          map <leader>sw :split<cr>
          map <leader>sv :vsplit<cr>
        '';

        # TODO
        # add unite + keybinds
        plugins = with pkgs.vimPlugins; [
          # FIXME
          {
            plugin = vim-startify;
          }
          editorconfig-vim
          delimitMate
          nerdtree
          vim-abolish
          vim-commentary
          vim-easymotion
          vim-diminactive
          vim-eunuch
          vim-fugitive
          vim-gitgutter
          vim-highlightedyank
          vim-indent-guides
          vim-obsession
          vim-repeat
          vim-rooter
          vim-signify
          vim-surround
          vim-unimpaired

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
            # plugin = vimfiler.vim;
            plugin = nerdtree;
            config = ''
              nmap <leader>d :NERDTreeToggle<CR>
              nmap <leader>de :NERDTreeToggleVCS<CR>
              nmap <leader>df :NERDTreeFind<CR>
            '';
          }

          vim-nix
          customVimPlugins."vim-denops/denops.vim"
          customVimPlugins."vim-denops/denops-helloworld.vim"
          customVimPlugins."Shougo/ddu.vim"
          {
            plugin = customVimPlugins."Shougo/ddu-ui-ff";
            config = ''
              call ddu#custom#patch_global({
                \ 'ui': 'ff',
                \ })
            '';
          }
          {
            plugin = customVimPlugins."Shougo/ddu-kind-file";
            config = ''
              call ddu#custom#patch_global({
                \   'kindOptions': {
                \     'file': {
                \       'defaultAction': 'open',
                \     },
                \   }
                \ })
            '';
          }
          {
            plugin = customVimPlugins."shun/ddu-source-rg";
            # https://github.com/shun/ddu-source-rg#configuration
            config = ''
              call ddu#custom#patch_global({
                \   'sourceParams' : {
                \     'rg' : {
                \       'args': ['--column', '--no-heading', '--color', 'never'],
                \     },
                \   },
                \ })
            '';
          }
          {
            plugin = customVimPlugins."shun/ddu-source-buffer";
            # https://github.com/shun/ddu-source-buffer#configuration
            config = ''
              " Use buffer source.
              call ddu#start({'sources': [{'name': 'buffer'}]})
            '';
          }
          # vim-devicons # load last
        ];
      };
    };
  };
}
