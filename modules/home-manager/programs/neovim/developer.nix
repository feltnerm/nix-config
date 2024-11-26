{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.feltnerm.programs.neovim.developer;
in
{
  options.feltnerm.programs.neovim.developer = {
    enable = lib.mkOption {
      description = "Enable developer-ey config/programs for neovim.";
      default = false;
    };
  };

  # extra, developer-ey vim packages/config
  config = lib.mkIf cfg.enable {
    feltnerm.programs.neovim = {
      completion.enable = lib.mkDefault true;
      lsp.enable = lib.mkDefault true;
      syntax.enable = lib.mkDefault true;
      telescope.enable = lib.mkDefault true;
      treesitter.enable = lib.mkDefault true;
      vimwiki.enable = lib.mkDefault true;

      ui = {
        enable = lib.mkDefault true;
        startify.enable = lib.mkDefault true;
      };
    };

    programs = {
      neovim = {
        plugins = with pkgs.vimPlugins; [
          nvim-lint
          conform-nvim
          markdown-preview-nvim
          playground
          {
            plugin = auto-save-nvim;
            type = "lua";
            config = ''
              require("auto-save").setup {}
            '';
          }
          {
            plugin = nerdtree;
            config = ''
              nmap <leader>d :NERDTreeToggle<CR>
              nmap <leader>de :NERDTreeToggleVCS<CR>
              nmap <leader>df :NERDTreeFind<CR>
            '';
          }
          {
            plugin = rest-nvim;
            type = "lua";
            config = ''
              require("rest-nvim").setup({})
            '';
          }

          # git-related
          git-blame-nvim
          vim-fugitive
          vim-gitgutter
          {
            plugin = vim-fugitive;
            config = ''
              nmap <space>G :Git<CR>
            '';
          }
        ];

        extraPackages = with pkgs; [
          git
          pyenv
          ripgrep
          universal-ctags
          yarn-berry

          luajitPackages.luarocks
        ];

        withNodeJs = true;
        withPython3 = true;
        withRuby = true;
      };
    };
  };
}
