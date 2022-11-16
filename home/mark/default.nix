{
  inputs,
  pkgs,
  ...
}: let
  cliPackages = with pkgs; [
    # shell
    bat
    exa
    fd
    jq
    readline
    ripgrep
    tmux

    # docker management:
    dive

    # base development environment
    # editorconfig

    # audio/image/video processing
    exiftool
    ffmpeg
    flac
    ghostscript
    imagemagick

    # browsers
    lynx
    surfraw # TODO surfraw configuration

    # file browsers
    mc #midnight commander
    ncdu
    ranger
    nnn

    # nix
    alejandra
    niv
    nix-index
    nixfmt
    statix

    # shell
    shellcheck

    # fun
    asciinema

    # spellingz
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    ispell
    hunspell
    hunspellDicts.en-us

    # cloud
    # awscli

    # web servers
    # caddy
  ];
in {
  imports = [];

  feltnerm = {
    # xdg.enable = true;

    programs = {
      readline.enable = true;
      ssh.enable = true;
      tmux.enable = true;
      zsh.enable = true;

      git = {
        enable = true;
        username = "feltnerm";
        # TODO better public email
        email = "feltner.mj@gmail.com";
        signCommits = true;
      };

      gpg = {
        pubKey = "3BBF0F96";
        enable = true;
      };
    };
  };

  home.packages = cliPackages;

  programs = {
    # CLI programs:
    bat.enable = true;
    command-not-found.enable = true;
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    dircolors = {
      enable = true;
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf = {
      enable = true;
      tmux = {
        #enableShellIntegration = true;
      };
    };
    htop.enable = true;
    info.enable = true;
    jq.enable = true;
    keychain = {
      enable = true;
      keys = ["id_ed25519_sk"];
    };

    # TODO rice my setup
    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };

  home = {
    # FIXME
    username = "mark";
    stateVersion = "22.05";
    homeDirectory = "/home/mark";

    shellAliases = {
      cat = "bat";

      g = "git";

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
      #MANPAGER = "sh -c 'col -bx | cat -l man -p'";
      #EDITOR = "vim";
      DROPBOX = "$HOME/Dropbox";
      WIKI = "$HOME/vimwiki_html";
      WIKI_SOURCE = "$HOME/vimwiki";
      CODE_HOME = "$HOME/code";
      PROJECTS = "$CODE_HOME";

      # GUI/Wayland
      MOZ_ENABLE_WAYLAND = 1;
      XDG_CURRENT_DESKTOP = "sway";
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

  # TODO
  # xdg.desktopEntries = {
  #   firefox = {
  #     name = "Firefox";
  #     genericName = "Web Browser";
  #     exec = "firefox %U";
  #     terminal = false;
  #     categories = ["Application" "Network" "WebBrowser"];
  #     mimeType = ["text/html" "text/xml" "application/json" "application/pdf"];
  #   };
  # };
}
