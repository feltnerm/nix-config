{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.neovim.lsp;

  nvimLspConfig = builtins.readFile ./nvim-lsp.lua;
  # TODO make per-language configs for the dev profile
in {
  options.feltnerm.neovim.lsp = {
    enable = lib.mkEnableOption "neovim lsp";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.extraPackages = with pkgs; [
      efm-langserver
      gopls
      jdt-language-server
      kotlin-language-server
      ltex-ls
      nil
      nodePackages.bash-language-server
      pyright
      rust-analyzer
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      nvim-jdtls # java language server
      rust-tools-nvim # rust tools
      lspkind-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = nvimLspConfig;
      }
    ];
  };
}
