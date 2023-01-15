# TODO caddy server that hosts wiki locally and auto-reloads or something
# should this be a module and the wiki source be a git-submodule or something?
{
  pkgs,
  config,
  ...
}: let
  wikiRoot = "$HOME/wiki";
  vimWiki = "${wikiRoot}/vimwiki";
  vimWikiHtml = "${wikiRoot}/vimwiki_html";

  plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-wiki;
      config = ''
        let g:vimwiki_global_ext = 0
        let g:vimwiki_list = [{'path': '~/${vimWiki}/', 'syntax': 'markdown', 'ext': '.md'}]
      '';
    }
    cmp-vimwiki-tags
  ];
in {
  config = {
    home = {
      sessionVariables = {
        WIKI = "${vimWikiHtml}";
        WIKI_SOURCE = "${vimWiki}";
      };
      shellAliases = {
        # TODO add alias to quick open wiki
        # TODO add alias to quickly search for wiki articles (using fzf!)
        #vwiki = "vim ${vimWiki}"
      };
    };

    programs.neovim = {
      extraPackages = with pkgs; [
        vimwiki-markdown
      ];
      inherit plugins;
    };
  };
}
