{
  pkgs,
  config,
  ...
}: {
  imports = [./fzf ./tmux];

  config = {
    home.shellAliases = {
      cat = "bat";
    };

    feltnerm = {
      config.xdg.enable = true;
      programs = {
        readline.enable = true;
        ssh.enable = true;
        tmux.enable = true;
        zsh.enable = true;
      };
    };

    programs = {
      bat.enable = true;
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

      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };

      starship = {
        enable = true;
        settings = {
          add_newline = true;
        };
      };
    };

    home.packages = with pkgs; [
      # docker management
      dive

      # audio/image/video processing
      exiftool
      ffmpeg
      flac
      ghostscript
      imagemagick

      # browsers
      lynx
      # TODO surfraw configuration
      surfraw

      # file browsers
      mc #midnight commander
      ncdu
      ranger
      nnn

      # nix
      niv

      # shell
      shellcheck

      # html validate/format
      tidyp

      # json, yaml, js, and more format
      nodePackages.prettier

      # fun
      asciinema
      ascii-image-converter
      nyancat
      youtube-dl

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
  };
}
