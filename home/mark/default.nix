{
  inputs,
  pkgs,
  config,
  lib,
  username,
  features,
  ...
}: {
  imports = [];
  # Import features that have modules
  # ++ builtins.filter builtins.pathExists (map (feature: "./${feature}") features);

  # TODO setup ~/bin
  # TODO profile => environment variables
  # TODO surfraw configuration
  # TODO ~/.config/feltnerm/{functions.sh,/bin}

  # options = lib.mkOption {
  #   username = username;
  # };

  feltnerm = {
    # config = {
    # };

    # xdg.enable = true;
    programs = {
      zsh.enable = true;
      tmux.enable = true;
      readline.enable = true;

      ssh.enable = true;
      gpg = {
        pubKey = "3BBF0F96";
        enable = true;
      };

      git = {
        enable = true;
        username = "feltnerm";
        # TODO better public email
        email = "feltner.mj@gmail.com";
        signCommits = true;
      };
    };
  };

  #programs.git.extraConfig.user.signgingKey = "3BBF0F96";

  # TODO system and/or home-manager packages?
  home.packages = with pkgs; [
    # cloud
    # awscli

    # web servers
    # caddy

    # docker management:
    dive
    # dry

    # editorconfig
    exiftool
    ffmpeg
    flac
    ghostscript
    imagemagick

    # browsers
    lynx
    surfraw

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

    # fun
    asciinema

    # spellingz
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    ispell
  ];

  programs = {
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

    # (neo)vim configuration
    vim.enable = true;
    neovim = {
      enable = true;
      withNodeJs = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    # TODO rice my setup
    powerline-go.enable = true;
  };

  home = {
    inherit username;
    # stateVersion = "22.05";
    homeDirectory = "/home/${username}";

    shellAliases = {
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
    sessionPath = [
      #"$HOME/.local/bin"
      #"\${xdg.configHome}/bin"
    ];

    sessionVariables = {
      #MANPAGER = "sh -c 'col -bx | cat -l man -p'";
      #EDITOR = "vim";
      DROPBOX = "$HOME/Dropbox";
      WIKI = "$HOME/vimwiki_html";
      WIKI_SOURCE = "$HOME/vimwiki";
      CODE_HOME = "$HOME/code";
      PROJECTS = "$CODE_HOME";
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
}
