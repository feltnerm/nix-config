{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.neovim.completion;

  nvimCmpConfig = builtins.readFile ./nvim-cmp.lua;
in {
  options.feltnerm.neovim.completion = {
    enable = lib.mkEnableOption "neovim completion";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.plugins = with pkgs.vimPlugins;
      [
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
      ]
      ++ (lib.lists.optional config.feltnerm.neovim.vimwiki.enable cmp-vimwiki-tags);
  };
}
