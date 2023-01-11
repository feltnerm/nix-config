{pkgs, ...}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;

  cocConfig = builtins.readFile ./coc.vim;
  cocPlugins = with pkgs.vimPlugins; [
    coc-clap
    coc-sh
    coc-json
    coc-html
  ];

  vimPlugins = with pkgs.vimPlugins;
    [
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
      {
        plugin = vim-clap;
        config = ''
          nmap <leader>p :Clap live_grep<CR>
          nmap <leader>pw :Clap live_grep ++query=<cword><CR>
          vmap <leader>pw :Clap live_grep ++query=@visual<CR>
          nmap <leader>P :Clap dumb_jump<CR>
          nmap <leader>Pw :Clap dumb_jump ++query=<cword><CR>
          vmap <leader>Pw :Clap dumb_jump ++query=@visual<CR>
          nmap <leader>pp :Clap blines<CR>
          nmap <leader>ppw :Clap blines ++query=<cword><CR>
          vmap <leader>ppw :Clap blines ++query=@visual<CR>
          nmap <leader>pf :Clap files<CR>
          nmap <leader>pF :Clap filer<CR>
          nmap <leader>pb :Clap buffers<CR>
          nmap <leader>pg :Clap git_files<CR>
          nmap <leader>pgc :Clap commits<CR>
          nmap <leader>pG :Clap git_diff_files<CR>
          nmap <leader>pr :Clap recent_files<CR>
          nmap <leader>py :Clap yanks<CR>
          nmap <leader>ph :Clap history <CR>
          nmap <leader>phc :Clap command_history<CR>
          nmap <leader>phs :Clap search_history<CR>
          nmap <leader>po :Clap lines<CR>
          nmap <leader>pq :Clap quickfix<CR>
          nmap <leader>pt :Clap tags<CR>
          nmap <leader>ptw :Clap tags ++query=<cword><CR>
          vmap <leader>ptw :Clap tags ++query=@visual<CR>
          nmap <leader>ppt :Clap proj_tags<CR>
          nmap <leader>ptw :Clap proj_tags ++query=<cword><CR>
          vmap <leader>ptw :Clap proj_tags ++query=@visual<CR>

          " make relative to entire editor
          let g:clap_layout = { 'relative': 'editor' }
        '';
      }
      vim-nix
      vim-devicons # load last
    ]
    ++ cocPlugins;
in {
  config = {
    feltnerm.programs = {
      neovim = {
        enable = true;
      };
    };

    programs.neovim = {
      coc = {
        enable = true;
        pluginConfig = cocConfig;
        settings = {
          "suggest.noselect" = true;
          "suggest.enablePreview" = true;
          "suggest.enablePreselect" = false;
          "suggest.disableKind" = true;
          languageserver = {
            "efm" = {
              "command" = "efm-langserver";
              "args" = [];
              #custom config path
              #"args": ["-c", "/path/to/your/config.yaml"],
              "filetypes" = ["vim" "eruby" "markdown"];
            };
            "nix" = {
              "command" = "rnix-lsp";
              "filetypes" = ["nix"];
            };
          };
        };
      };
      extraPackages = [pkgs.deno pkgs.universal-ctags pkgs.efm-langserver pkgs.rnix-lsp pkgs.nodejs pkgs.ripgrep pkgs.shellcheck];
      extraConfig = feltnermVimrc;
      plugins = vimPlugins;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
