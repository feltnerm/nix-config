{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.feltnerm.programs.neovim.vimwiki;
in {
  options.feltnerm.programs.neovim.vimwiki = {
    enable = lib.mkOption {
      description = "Enable vimwiki.";
      default = false;
    };

    wikisRoot = lib.mkOption {
      description = "Root path for wikis to live.";
      default = "wiki";
    };

    wikis = lib.mkOption {
      description = "Wikis to manage.";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          # if undefined/null, then use convention path via wiki root based on name
          name = lib.mkOption {
            description = "Define the wiki name.";
            type = lib.types.nullOr lib.types.str;
            default = "";
          };

          # if undefined/null, then use convention path via wiki root based on name
          # path = "${cfg.wikiRoot}/${name}";
          path = lib.mkOption {
            description = "Define a path to wiki source. Defaults to a sub-directory of the wiki root.";
            type = lib.types.nullOr lib.types.str;
            default = null;
          };

          # use default if not defined
          ext = lib.mkOption {
            description = "extension to use.";
            default = ".md";
          };

          # use default if not defined
          syntax = lib.mkOption {
            description = "Syntax to use.";
            type = lib.types.enum ["default" "markdown" "media"];
            default = "markdown";
          };

          # TODO
          # extra_wiki_options = lib.mkOption {
          #   description = "Extra options to pass to the wiki configuration (see `:help vimwiki`).";
          #   # type = lib.types.submodule { freeformType = formatter.type; };
          #   type = lib.types.attrsOf (lib.types.submodule {freeformType = lib.types.attrsOf lib.types.str;});
          #   # type = lib.types.listOf (lib.types.submodule {freeformType = lib.types.attrsOf lib.types.str;});
          #   default = {};
          # };
        };
      });
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      sessionVariables = {
        WIKI = "${config.home.homeDirectory}/${cfg.wikisRoot}";
      };
      shellAliases = {
        # TODO add alias to quick open wiki
        # TODO add alias to quickly search for wiki articles (using fzf!)
      };

      # add this file to ensure directories are created
      file."${cfg.wikisRoot}/.keep".text = "";
    };

    programs.neovim = let
      # apply defaults, then apply our wiki config overrides
      vimWikiWikisConfig = builtins.mapAttrs (name: wiki:
        {
          inherit name;
          inherit (wiki) ext;
          inherit (wiki) syntax;
        }
        # set a path when undefined
        // (
          if builtins.isNull wiki.path
          then {path = "${config.home.homeDirectory}/${cfg.wikisRoot}/${name}";}
          else {inherit (wiki) path;}
        ))
      cfg.wikis;

      vimWikiConfig = with pkgs.vimPlugins; {
        plugin = vimwiki;
        config = ''
          let g:vimwiki_global_ext = 0
          let g:vimwiki_dir_link = 'index'
          let g:vimwiki_list = ${builtins.toJSON (builtins.attrValues vimWikiWikisConfig)}
        '';
      };
    in {
      extraPackages = with pkgs; [vimwiki-markdown];
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        #cmp-vimwiki-tags
        vimWikiConfig
      ];
    };
  };
}
