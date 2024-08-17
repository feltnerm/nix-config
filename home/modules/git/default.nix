{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.git;
  gitIgnore = lib.strings.splitString "\n" (builtins.readFile ./gitignore);
in {
  options.feltnerm.git = {
    enable = lib.mkEnableOption "git";

    username = lib.mkOption {
      description = "Git username";
      type = lib.types.str;
    };

    email = lib.mkOption {
      description = "Git email address";
      type = lib.types.str;
    };

    signCommits = lib.mkEnableOption "sign commits";

    # TODO
    # allowedSignersFile = lib.mkOption {
    #   description = "Allowed SSH file for signing";
    #   default = "";
    # };

    # TODO
    # commitTemplate = with config.feltnerm.git;
    #   pkgs.writeTextFile {
    #     name = "${username}";
    #     text = ''

    #       Signed-off-by: ${username} <${email}>
    #     '';
    #   };
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = {
      g = "git";
    };

    home.packages = [pkgs.git-quick-stats];

    # persist ssh sessions to github for a short while
    programs.ssh = {
      matchBlocks = {
        "github.com" = {
          extraOptions = {
            "ControlMaster" = "auto";
            "ControlPath" = "~/.ssh/S.%r@%h:%p";
            "ControlPersist" = "5m";
          };
        };
      };
    };

    programs.git = {
      enable = true;
      userName = "${cfg.username}";
      userEmail = "${cfg.email}";
      diff-so-fancy = {
        enable = true;
      };
      ignores = gitIgnore;
      aliases = {
        br = "branch";
        c = "commit -am";
        ci = "commit";
        co = "checkout";
        dad = "!curl https://icanhazdadjoke.com/ && git add";
        df = "diff --color --color-words --abbrev";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
        p = "push";
        pl = "pull";
        pom = "push origin main";
        ps = "push";
        ri = "rebase --interactive --autosquash";
        st = "status";
        # fixup = "!sh -c 'git commit -m \"fixup! $(git log -1 --format='\\'%s'\\' $@)\"' -";
        # squash = "!sh -c 'git commit -m \"squash! $(git log -1 --format='\\'%s'\\' $@)\"' -";
      };

      extraConfig = lib.mkMerge [
        {
          color.ui = "auto";
          core.editor = "vim";
          core.ignorecase = false;

          delta.enable = true;
          init.defaultBranch = "main";
          pull.rebase = "true";
          push.default = "current";
          tag.sort = "version:refname";

          status = {
            short = true;
            branch = true;
          };

          # https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/
          # https://stackoverflow.com/questions/27417656/should-diff3-be-default-conflictstyle-on-git
          merge.conflictstyle = "diff3";
          merge.log = true;

          # TODO ?
          #protocol.keybase.allow = "always";

          # TODO
          # commit.template = "${commitTemplate}";
          # credential.helper = "store --file ~/.git-credentials";

          # TODO
          url = {
            # "git@github.com:" = {
            #   insteadOf = "gh:";
            # };
            # "git@github.com:".insteadOf "github:";
          };
        }
        (
          lib.mkIf cfg.signCommits {
            format.signoff = true;
            commit.gpgSign = true;
            user.signingkey = "${config.feltnerm.gpg.pubKey}";
            gpg = {
              #format = "ssh";
              #ssh = {
              #  defaultKeyCommand = "${pkgs.openssh}/bin/ssh-add -L";
              #  programs = "${pkgs.openssh}/bin/ssh-keygen";
              #  #    # TODO
              #  #    # allowedSignersFile = cfg.allowedSignerFile;
              #};
            };
          }
        )
      ];
    };
  };
}
#TODO
# - add script to clone into ~/code

