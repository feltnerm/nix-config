{
  pkgs,
  config,
  ...
}: let
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
  config = {
    programs.neovim.extraPackages = languageServers;
    programs.neovim.plugins = vimLanguageServerPlugins;
  };
}
