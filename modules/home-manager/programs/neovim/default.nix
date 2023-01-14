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
          delimitMate
          editorconfig-vim
          vim-abolish
          vim-commentary
          vim-diminactive
          vim-eunuch
          {
            plugin = vim-fugitive;
            config = ''
              nmap <space>G :Git<CR>
            '';
          }
          vim-fugitive
          vim-gitgutter
          vim-highlightedyank
          vim-indent-guides
          vim-obsession
          vim-repeat
          vim-rooter
          vim-signify
          vim-sleuth
          vim-sneak
          vim-surround
          vim-table-mode
          vim-unimpaired
        ];
      };
    };
  };
}
