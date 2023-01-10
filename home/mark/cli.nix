{
  pkgs,
  ...
}: let
  cliPackages = with pkgs; [
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
    home-manager
    niv
    nix-index

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
  home.packages = cliPackages;

  home.shellAliases = {
    cat = "bat";
  };

  feltnerm = {
    config.xdg.enable = true;
    programs = {
      neovim.enable = true;
      readline.enable = true;
      ssh.enable = true;
      tmux.enable = true;
      zsh.enable = true;
    };
  };

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

    starship = {
      enable = true;
      settings = {
        add_newline = true;
      };
    };
  };
}
