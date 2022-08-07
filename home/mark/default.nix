{
  inputs,
  pkgs,
  config,
  lib,
  username,
  features,
  ...
}: {
  imports = [ ];
    # Import features that have modules
    # ++ builtins.filter builtins.pathExists (map (feature: "./${feature}") features);

  # TODO setup ~/bin
  # TODO profile => environment variables
  # TODO surfraw configuration
  # TODO ~/.config/feltnerm/{functions.sh,/bin}

  feltnerm = {
    # config = {
    # };

    # xdg.enable = true;
    programs = {
      readline.enable = true;
      tmux.enable = true;
      zsh.enable = true;

      git = {
        enable = true;
        username = "feltnerm";
        # TODO better public email
        email = "feltner.mj@gmail.com";
      };
    };
  };

  home.packages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    # awscli
    # caddy
    diff-so-fancy

    # docker management:
    dive
    # dry

    # editorconfig
    exiftool
    ffmpeg
    flac
    fpp
    ghostscript
    hexyl
    httpie
    imagemagick
    ispell
    lynx
    mc #midnight commander
    ncdu
    nnn
    ranger
    surfraw
  ];

  programs = {
    bat.enable = true;
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    exa.enable = true;
    htop.enable = true;
    jq.enable = true;
    keychain.enable = true; # TODO configure keychain, ssh, gpg, etc.

    # (neo)vim configuration
    # TODO decide!
    vim.enable = true;
    neovim = {
      enable = true;
      withNodeJs = true;
    };
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

      l = "ls";
      lsd = "ls -l";
      ll = "ls -l";
      lh = "ls -h";
      la = "ls -la";
      lad = "ls -lah";

      weather = "curl wttr.in";
      oracow = "fortune | cowsay";

      # TODO only override these commands if the alias is installed
      cat = "bat";
      ls = "exa";
    };

    # extra directories to add to $PATH
    sessionPath = [
      "$HOME/.local/bin"
      "\${xdg.configHome}/bin"
    ];

    sessionVariables = {
      MANPAGER = "sh -c 'col -bx | cat -l man -p'";
      EDITOR = "vim";
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
