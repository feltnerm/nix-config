{lib, ...}: {
  imports = [./cli.nix];

  config = {
    feltnerm = {
      programs = {
        git = {
          enable = lib.mkDefault true;
          username = lib.mkDefault "feltnerm";
          # TODO better public email
          email = lib.mkDefault "feltner.mj@gmail.com";
          signCommits = lib.mkDefault true;
        };

        gpg = {
          pubKey = lib.mkDefault "3BBF0F96";
          enable = lib.mkDefault true;
        };
      };
    };

    programs = {
      keychain = {
        enable = lib.mkDefault true;
        keys = lib.mkDefault ["id_ed25519_sk"];
      };
    };

    home = {
      stateVersion = "22.05";

      shellAliases = {
        cp = "cp -i"; # write error instead of overwriting
        cpv = "rsync -pogr --progress";
        cpp = "rsync -Wavp --human-readable --progress $1 $2";

        mv = "mv -i";
        rm = "rm -ir";

        weather = "curl wttr.in";
        oracow = "fortune | cowsay";
      };

      # extra directories to add to $PATH
      # TODO setup ~/bin
      # TODO ~/.config/feltnerm/{functions.sh,/bin}
      sessionPath = [
        #"$HOME/.local/bin"
        #"\${xdg.configHome}/bin"
      ];

      # TODO profile => environment variables
      sessionVariables = {
        DROPBOX = "$HOME/Dropbox";
        WIKI = "$HOME/vimwiki_html";
        WIKI_SOURCE = "$HOME/vimwiki";
        CODE_HOME = "$HOME/code";
        PROJECTS = "$CODE_HOME";

        # GUI/Wayland
        #MOZ_ENABLE_WAYLAND = 1;
        #XDG_CURRENT_DESKTOP = "sway";
      };
    };

    # home.file = {};
    home.file = {
      ".hushlogin" = {
        text = "";
      };

      ".editorconfig" = {
        text = ''
          # editorconfig.org
          root = true

          [*]
          charset = utf-8
          end_of_line = lf
          trim_trailing_whitespace = true
          insert_final_newline = true

          [*.{json,yaml,yml,toml,tml}]
          indent_style = space
          indent_size = 2

          [Makefile]
          indent_style = tab
        '';
      };
    };
  };
}
