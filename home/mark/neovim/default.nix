{
  pkgs,
  lib,
  ...
}: let
  feltnermVimrc = builtins.readFile ./vimrc.vim;

  # TODO

  vimPlugins = with pkgs.vimPlugins; [
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
  ];
in {
  config = {
    feltnerm.programs = {
      neovim = {
        enable = true;

        completion.enable = true;
        lsp.enable = true;
        syntax.enable = true;
        telescope.enable = true;
        treesitter.enable = true;
        ui = {
          enable = true;
          startify = {
            enable = true;
            extraConfig = lib.mkDefault ''
              let g:startify_header = system('chuckscii')
              let g:startify_custom_header =
                \ startify#center(split(startify_header, '\n')) +
                \ startify#center([""]) +
                \ startify#center(startify#fortune#boxed()) +
                \ startify#center([""]) +
                \ startify#center(split(system('date -R'), '\n')) +
                \ startify#center([""]) +
                \ startify#center(split(system('year-progress 100'), '\n'))
            '';
          };
        };
        vimwiki.enable = true;
      };
    };

    programs.neovim = {
      extraPackages = [
        pkgs.universal-ctags
        pkgs.ripgrep
      ];
      extraConfig = feltnermVimrc;
      plugins = vimPlugins;
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
    };
  };
}
