{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.feltnerm.profiles.developer;
in {
  options.feltnerm.profiles.developer.code = {
    enable = lib.mkOption {
      description = "Enable the $CODE directory.";
      default = true;
    };

    codeDir = lib.mkOption {
      description = "Set the the directory";
      default = "$HOME/code";
    };
  };

  config = lib.mkIf cfg.enable {
    feltnerm = {
      # inherit the minimal profile
      programs = {
        fzf.enable = true;
        git.enable = true;
        gpg.enable = true;
        readline.enable = true;
        ssh.enable = true;
        tmux.enable = true;
        zsh.enable = true;

        neovim = {
          enable = true;

          completion.enable = true;
          lsp.enable = true;
          syntax.enable = true;
          telescope.enable = true;
          treesitter.enable = true;
          vimwiki.enable = true;

          ui = {
            enable = true;
            startify = {
              enable = true;
              extraConfig = ''
                let g:startify_header = system('chuckscii')
                let g:startify_custom_header =
                  \ startify#center(split(startify_header, '\n')) +
                  \ startify#center([""]) +
                  \ startify#center(startify#fortune#boxed()) +
                  \ startify#center([""]) +
                  \ startify#center(split(system('date -R'), '\n')) +
                  \ startify#center([""]) +
                  \ startify#center(split(system('year-progress 100'), '\n'))
              '';
            };
          };
        };
      };
    };

    home = {
      sessionVariables = lib.mkIf cfg.code.enable {
        CODE_HOME = cfg.code.codeDir;
      };

      file.".editorconfig" = {
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

      # developer-ey packages
      packages = with pkgs; [
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
  };
}
