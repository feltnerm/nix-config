{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.feltnerm.programs.neovim.treesitter;

  treesitterConfig = builtins.readFile ./nvim-treesitter.lua;
  treesitterRefactorConfig = builtins.readFile ./nvim-treesitter-refactor.lua;

  treesitterPlugins = with pkgs.vimPlugins; [
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

  treesitterPackages = with pkgs; [
    tree-sitter
  ];
in
{
  options.feltnerm.programs.neovim.treesitter = {
    enable = lib.mkOption {
      description = "Enable neovim treesitter";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      extraPackages = treesitterPackages;
      plugins = treesitterPlugins;
      extraConfig = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set nofoldenable  " Disable folding at startup.
      '';
    };
  };
}
