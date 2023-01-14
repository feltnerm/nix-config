{pkgs, ...}: let
  nvimCmpConfig = builtins.readFile ./nvim-cmp.lua;

  cmpPlugins = with pkgs.vimPlugins; [
    cmp-buffer
    cmp-nvim-tags
    cmp-nvim-lsp-document-symbol
    cmp-nvim-lsp-signature-help
    cmp-nvim-lsp
    cmp-git
    cmp-path
    {
      plugin = nvim-cmp;
      type = "lua";
      config = nvimCmpConfig;
    }
  ];
in {
  config = {
    programs.neovim.plugins = cmpPlugins;
  };
}
