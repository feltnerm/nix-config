# TODO caddy server that hosts wiki locally and auto-reloads or something
# should this be a module and the wiki source be a git-submodule or something?
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.vimwiki;

  plugins = with pkgs.vimPlugins; [
    plenary-nvim
    #cmp-vimwiki-tags
    {
      plugin = vimwiki;
      config = ''
        let g:vimwiki_global_ext = 0
        let g:vimwiki_list = [{'path': '${cfg.vimWikiRoot}', 'syntax': 'markdown', 'ext': '.md'}]
      '';
    }
  ];
in {
  options.feltnerm.programs.neovim.vimwiki = {
    enable = lib.mkOption {
      description = "Enable vimwiki";
      default = false;
    };

    enableMarkdown = lib.mkOption {
      description = "Enable markdown for vimwiki";
      default = false;
    };

    wikiRoot = lib.mkOption {
      description = "Root of the vimwiki source";
      default = "$HOME/wiki";
    };

    vimWikiRoot = lib.mkOption {
      description = "Root of the vimwiki source";
      default = "${cfg.wikiRoot}/vimwiki";
    };

    vimWikiHtmlOut = lib.mkOption {
      description = "Directory for the vimwiki HTML output";
      default = "${cfg.wikiRoot}/vimwiki_html";
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        WIKI = "${cfg.vimWikiHtmlOut}";
        WIKI_SOURCE = "${cfg.vimWikiRoot}";
      };
      shellAliases = {
        # TODO add alias to quick open wiki
        # TODO add alias to quickly search for wiki articles (using fzf!)
      };
    };

    programs.neovim = {
      extraPackages = with pkgs;
        []
        ++ (
          if cfg.enableMarkdown
          then [vimwiki-markdown]
          else []
        );
      inherit plugins;
    };
  };
}
