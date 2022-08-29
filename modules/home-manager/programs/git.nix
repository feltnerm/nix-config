{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.git;
in {
  options.feltnerm.programs.git = {
    enable = lib.mkOption {
      description = "Enable git";
      default = false;
    };

    username = lib.mkOption {
      description = "Git username";
      type = lib.types.str;
      default = "";
    };

    email = lib.mkOption {
      description = "Git email address";
      type = lib.types.str;
      default = "";
    };

    signCommits = lib.mkOption {
      description = "Whether to sign commits with GPG";
      default = true;
    };

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
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = cfg.username;
      userEmail = cfg.email;
      #ignores = ["*~" "*.swp" "*.#"];
      extraConfig = {
        commit.gpgSign = cfg.signCommits;
        gpg = {
          format = "ssh";
          ssh = {
            defaultKeyCommand = "${pkgs.openssh}/bin/ssh-add -L";
            programs = "${pkgs.openssh}/bin/ssh-keygen";
        #    # TODO
        #    # allowedSignersFile = cfg.allowedSignerFile;
          };
        };
        color.ui = "auto";
        core.editor = "vim";
        delta.enable = true;
        # TODO: enable once it is all working
        format.signoff = cfg.signCommits;
        init.defaultBranch = "main";
        pull.rebase = "true";
        push.default = "current";

        # https://blog.nilbus.com/take-the-pain-out-of-git-conflict-resolution-use-diff3/
        # https://stackoverflow.com/questions/27417656/should-diff3-be-default-conflictstyle-on-git
        merge.conflictstyle = "zdiff3";

        # TODO ?
        #protocol.keybase.allow = "always";

        # TODO
        # commit.template = "${commitTemplate}";
        # credential.helper = "store --file ~/.git-credentials";

        # TODO
        url = {
          #"git@github.com:".insteadOf = "https://github.com/";
        };
      };
    };
  };
}
#TODO
# - add script to clone into ~/code

