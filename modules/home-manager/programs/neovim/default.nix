{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim;

  defaultVimPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    delimitMate
    editorconfig-vim
    git-blame-nvim
    vim-abolish
    vim-commentary
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
    vim-sleuth
    vim-sneak
    vim-surround
    vim-table-mode
    vim-unimpaired
    {
      plugin = vim-fugitive;
      config = ''
        nmap <space>G :Git<CR>
      '';
    }
    {
      plugin = nvim-autopairs;
      type = "lua";
      config = ''
        require("nvim-autopairs").setup {}
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
  imports = [./completion ./lsp ./telescope ./treesitter ./syntax.nix ./ui.nix ./vimwiki.nix];

  options.feltnerm.programs.neovim = {
    enable = lib.mkOption {
      description = "Enable a base neovim setup.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = [
          pkgs.git
          pkgs.ripgrep
          pkgs.universal-ctags
        ];

        # base set of vim plugins, when enabled
        plugins = defaultVimPlugins;
      };
    };
  };
}
