{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.neovim;
in {
  options.feltnerm.programs.neovim = {
    enable = lib.mkOption {
      description = "Enable neovim";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      neovim = {
        enable = true;
        defaultEditor = true;
        vimAlias = true;
        vimdiffAlias = true;

        extraPackages = [pkgs.git];

        # base set of vim plugins, when enabled
        plugins = with pkgs.vimPlugins; [
          # FIXME
          {
            plugin = vim-startify;
          }
          delimitMate
          editorconfig-vim
          nerdtree
          vim-abolish
          vim-commentary
          vim-diminactive
          vim-easymotion
          vim-eunuch
          vim-fugitive
          vim-gitgutter
          vim-highlightedyank
          vim-indent-guides
          vim-obsession
          vim-repeat
          vim-rooter
          vim-signify
          vim-sleuth
          vim-surround
          vim-unimpaired
        ];
      };
    };
  };
}
