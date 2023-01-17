{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.syntax;

  syntaxPlugins = with pkgs.vimPlugins; [
    kotlin-vim
    rust-vim
    vim-markdown
    vim-nix
    vim-toml
  ];
in {
  options.feltnerm.programs.neovim.syntax = {
    enable = lib.mkOption {
      description = "Enable extra neovim syntaxes.";
      default = false;
    };
  };

  config = {
    programs.neovim.plugins = lib.mkIf cfg.enable syntaxPlugins;
  };
}
