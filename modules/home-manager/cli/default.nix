{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.cli;
in {
  imports = [./fzf ./neovim ./tmux];

  options.feltnerm.cli = {
    enable = lib.mkOption {
      description = "Enable pre-customized CLI.";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      cat = "bat";
    };

    feltnerm = {
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
      bitwarden-cli

      # docker management
      dive

      # audio/image/video processing
      exiftool
      ffmpeg
      flac
      ghostscript
      image_optim
      imagemagick
      nodePackages.svgo

      # browsers
      lynx
      # TODO surfraw configuration
      surfraw

      # file browsers
      mc #midnight commander
      ncdu_1 # FIXME once zig is stable
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

      # process mgmt
      glances
      #gotop
      nodePackages.nodemon

      # yubikey
      yubikey-agent
      yubikey-manager
      yubikey-personalization

      # fun
      ascii-image-converter
      asciinema
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
