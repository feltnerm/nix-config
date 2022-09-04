{
  inputs,
  pkgs,
  config,
  lib,
  username,
  features,
  ...
}: let
  cliPackages = with pkgs; [
    # cloud
    # awscli

    # web servers
    # caddy

    # docker management:
    dive
    # dry

    # editorconfig
    exiftool
    ffmpeg
    flac
    ghostscript
    imagemagick

    # browsers
    lynx
    surfraw

    # file browsers
    mc #midnight commander
    ncdu
    ranger
    nnn

    # nix
    alejandra
    niv
    nix-index
    nixfmt
    statix

    # shell
    shellcheck

    # fun
    asciinema

    # spellingz
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    ispell
    hunspell
    hunspellDicts.en-us
  ];

  guiPackages = with pkgs; [
    alacritty
    firefox
  ];
in {
  imports = [];
  # Import features that have modules
  # ++ builtins.filter builtins.pathExists (map (feature: "./${feature}") features);

  # TODO setup ~/bin
  # TODO ~/.config/feltnerm/{functions.sh,/bin}
  # TODO profile => environment variables
  # TODO surfraw configuration

  feltnerm = {
    # xdg.enable = true;
    programs = {
      zsh.enable = true;
      tmux.enable = true;
      readline.enable = true;
      ssh.enable = true;
      gpg = {
        pubKey = "3BBF0F96";
        enable = true;
      };
      git = {
        enable = true;
        username = "feltnerm";
        # TODO better public email
        email = "feltner.mj@gmail.com";
        signCommits = true;
      };
    };
  };

  # TODO system and/or home-manager packages?
  home.packages = cliPackages ++ guiPackages;

  programs = {
    # GUI programs:
    # TODO based on GUI-ness
    alacritty = {
      enable = true;
      settings = {};
    };

    firefox = {
      enable = true;
    };

    waybar = {
      enable = true;
    };

    # CLI programs:
    bat.enable = true;
    command-not-found.enable = true;
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    dircolors = {
      enable = true;
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf = {
      enable = true;
      tmux = {
        #enableShellIntegration = true;
      };
    };
    htop.enable = true;
    info.enable = true;
    jq.enable = true;
    keychain = {
      enable = true;
      keys = ["id_ed25519_sk"];
    };

    # (neo)vim configuration
    vim.enable = true;
    neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      vimdiffAlias = true;

      #coc = {
      #  enable = true;
      #};

      extraPackages = [pkgs.git];

      extraConfig = ''
        map <space> <leader>

        lang en_US

        set modeline
        set magic
        set smartcase
        set autoindent
        set tabstop=4
        set shiftwidth=4
        set softtabstop=4
        set expandtab
        set nojoinspaces

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
        {
          plugin = vim-startify;
          config = "let g:startify_change_to_vcs_root = 0";
        }
        delimitMate
        vim-abolish
        vim-commentary
        vim-eunuch
        vim-fugitive
        vim-highlightedyank
        vim-indent-guides
        vim-obsession
        vim-repeat
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

        editorconfig-vim
        vim-gitgutter
        {
          plugin = vim-gitgutter;
          #config = ''
          #  let g:gitgutter_realtime = 1;
          #'';
        }
        vim-rooter
        #{
        #  plugin = vimfiler.vim;
        #  config = ''
        #    let g:vimfiler_as_default_explorer = 1
        #    nmap <leader>d :VimFiler -buffer-name=explorer -simple -toggle<CR>
        #    nmap <leader>de :VimFiler -buffer-name=explorer -toggle<CR>
        #    nmap <leader>df :VimFilerBufferDir -buffer-name=explorer -toggle<CR>
        #  '';
        #}

        vim-nix
      ];
    };

    # TODO rice my setup
    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };

  home = {
    inherit username;
    # stateVersion = "22.05";
    homeDirectory = "/home/${username}";

    shellAliases = {
      g = "git";
      cp = "cp -i"; # write error instead of overwriting
      cpv = "rsync -pogr --progress";
      cpp = "rsync -Wavp --human-readable --progress $1 $2";
      mv = "mv -i";
      rm = "rm -ir";
      weather = "curl wttr.in";
      oracow = "fortune | cowsay";
    };

    # extra directories to add to $PATH
    sessionPath = [
      #"$HOME/.local/bin"
      #"\${xdg.configHome}/bin"
    ];

    sessionVariables = {
      #MANPAGER = "sh -c 'col -bx | cat -l man -p'";
      #EDITOR = "vim";
      DROPBOX = "$HOME/Dropbox";
      WIKI = "$HOME/vimwiki_html";
      WIKI_SOURCE = "$HOME/vimwiki";
      CODE_HOME = "$HOME/code";
      PROJECTS = "$CODE_HOME";
    };
  };

  # home.file = {};
  home.file = {
    ".hushlogin" = {
      text = "";
    };

    ".editorconfig" = {
      text = ''
        # editorconfig.org
        root = true

        [*]
        charset = utf-8
        end_of_line = lf
        trim_trailing_whitespace = true
        insert_final_newline = true

        [*.{json,yaml,yml,toml,tml}]
        indent_style = space
        indent_size = 2

        [Makefile]
        indent_style = tab
      '';
    };
  };

  xdg.desktopEntries = {
    firefox = {
      name = "Firefox";
      genericName = "Web Browser";
      exec = "firefox %U";
      terminal = false;
      categories = ["Application" "Network" "WebBrowser"];
      mimeType = ["text/html" "text/xml" "application/json" "application/pdf"];
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      menu = "\{$pkgs.wofi}/bin/wofi --show drun";
      terminal = "\${pkgs.alacritty/bin/alacritty}";
    };
    extraConfig = ''
      set $cursor_size 54

      set $gnome-schema org.gnome.desktop.interface
      exec_always {
        gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
      }

      seat seat0 xcursor_theme breeze 54

      #exec swayidle -w \
      #  timeout 1800 'swaylock -f'
      #  timeout 1805 'swaymsg "output * dpms off"' \
      #  resume 'swaymsg "output * dpms on"'

      exec dbus-sway-environment
      exec configure-gtk
    '';
    wrapperFeatures = {
      gtk = true;
    };
  };

  services.swayidle.enable = true;
}
