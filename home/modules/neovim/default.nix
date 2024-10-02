{
  pkgs,
  config,
  lib,
  homeModules,
  ...
}: let
  cfg = config.feltnerm.neovim;

  defaultVimPlugins = with pkgs.vimPlugins; [
    plenary-nvim
    delimitMate
    editorconfig-vim
    vim-abolish
    vim-commentary
    vim-diminactive
    vim-eunuch
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

  feltnermVimrc = builtins.readFile ./vimrc.vim;
in {
  imports = [
    "${homeModules}/neovim/completion"
    "${homeModules}/neovim/developer.nix"
    "${homeModules}/neovim/lsp"
    "${homeModules}/neovim/telescope"
    "${homeModules}/neovim/treesitter"
    "${homeModules}/neovim/syntax.nix"
    "${homeModules}/neovim/ui.nix"
    "${homeModules}/neovim/vimwiki.nix"
  ];

  options.feltnerm.neovim = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      neovim = {
        enable = true;

        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraConfig = feltnermVimrc;

        extraPackages = [
          pkgs.ripgrep
        ];

        # base set of vim plugins, when enabled
        plugins = defaultVimPlugins;
      };
    };
  };
}
