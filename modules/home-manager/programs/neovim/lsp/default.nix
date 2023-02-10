{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.lsp;

  nvimLspConfig = builtins.readFile ./nvim-lsp.lua;

  languageServers = with pkgs; [
    efm-langserver
    gopls
    jdt-language-server
    kotlin-language-server
    nil
    nodePackages.bash-language-server
    pyright
    rust-analyzer
  ];

  vimLanguageServerPlugins = with pkgs.vimPlugins; [
    nvim-jdtls # java language server
    rust-tools-nvim # rust tools
    lspkind-nvim
    {
      plugin = nvim-lspconfig;
      type = "lua";
      config = nvimLspConfig;
    }
  ];
in {
  options.feltnerm.programs.neovim.lsp = {
    enable = lib.mkOption {
      description = "Enable LSP servers for neovim.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.extraPackages = languageServers;
    programs.neovim.plugins = vimLanguageServerPlugins;
  };
}
