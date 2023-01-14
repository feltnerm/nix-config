{pkgs, ...}: let
  syntaxPlugins = with pkgs.vimPlugins; [
    kotlin-vim
    rust-vim
    vim-markdown
    vim-nix
    vim-toml
  ];
in {
  config = {};
}
