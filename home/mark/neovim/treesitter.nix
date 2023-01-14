{pkgs, ...}: let
  treesitterConfig = builtins.readFile ./nvim-treesitter.lua;
  treesitterRefactorConfig = builtins.readFile ./nvim-treesitter-refactor.lua;

  treesitterPlugins = with pkgs.vimPlugins; [
    # treesitter
    {
      plugin = nvim-treesitter.withAllGrammars;
      type = "lua";
      config = treesitterConfig;
    }
    {
      plugin = nvim-treesitter-refactor;
      type = "lua";
      config = ''
      '';
    }
  ];

  treesitterPackages = with pkgs; [
    tree-sitter
  ];
in {
  config = {
    programs.neovim.extraPackages = treesitterPackages;
    programs.neovim.plugins = treesitterPlugins;
    programs.neovim.extraConfig = ''
      set foldmethod=expr
      set foldexpr=nvim_treesitter#foldexpr()
      set nofoldenable                     " Disable folding at startup.
    '';
  };
}
