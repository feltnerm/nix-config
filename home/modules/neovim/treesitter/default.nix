{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.neovim.treesitter;

  treesitterConfig = builtins.readFile ./nvim-treesitter.lua;
  treesitterRefactorConfig = builtins.readFile ./nvim-treesitter-refactor.lua;
in {
  options.feltnerm.neovim.treesitter = {
    enable = lib.mkEnableOption "neovim treesitter";
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      extraPackages = with pkgs; [
        tree-sitter
      ];
      plugins = with pkgs.vimPlugins; [
        # treesitter
        nvim-treesitter-textobjects
        {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = treesitterConfig;
        }
        {
          plugin = nvim-treesitter-refactor;
          type = "lua";
          config = treesitterRefactorConfig;
        }
      ];
      extraConfig = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable  " Disable folding at startup.
      '';
    };
  };
}
