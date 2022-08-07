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
      description = "username";
      type = lib.types.str;
      default = "";
    };

    email = lib.mkOption {
      description = "email";
      type = lib.types.str;
      default = "";
    };

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
      ignores = ["*~" "*.swp" "*.#"];
      delta.enable = true;
      extraConfig = {
        color.ui = "auto";
        core.editor = "vim";
        format.signoff = true;
        init.defaultBranch = "main";
        pull.rebase = "true";
        push.default = "current";

        # TODO ?
        protocol.keybase.allow = "always";

        # TODO
        # commit.template = "${commitTemplate}";
        # credential.helper = "store --file ~/.git-credentials";

        # TODO
        url = {
          #"git@github.com:".insteadOf = "https://github.com/";
          #"git@ssh.tulpa.dev:".insteadOf = "https://tulpa.dev/";
        };
      };
    };
  };
}
