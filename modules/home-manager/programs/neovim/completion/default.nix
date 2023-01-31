{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.completion;

  nvimCmpConfig = builtins.readFile ./nvim-cmp.lua;

  cmpPlugins = with pkgs.vimPlugins;
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
    ++ (
      if config.feltnerm.programs.neovim.vimwiki.enable
      then [cmp-vimwiki-tags]
      else []
    );
in {
  options.feltnerm.programs.neovim.completion = {
    enable = lib.mkOption {
      description = "Enable neovim code completion.";
      default = false;
    };
  };

  # TODO conditionally add `vimPlugins.cpm-vimwiki-tags`

  config = {
    programs.neovim.plugins = lib.mkIf cfg.enable cmpPlugins;
  };
}
