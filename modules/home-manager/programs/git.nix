{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.feltnerm.programs.git;

  gitIgnores = [
    # metadata files
    "env.sh"
    ".env"
    ".direnv"
    ".metadata"
    "*.#"
    "*.bak"
    "*.swp"
    "*.tmp"
    "*~"
    "*~.nib"
    ".fuse_hidden*"
    ".directory"
    ".Trash-*"
    ".nfs*"
    "tmp/"
    "local.properties"
    ".settings/"
    ".loadpath"
    ".recommenders"

    # other VCS
    ".bzr/"
    ".bzrignore"
    "/CVS/*"
    ".cvsignore"
    "*/.cvsignore"

    # ides
    ".project"
    ".launch"
    "*.launch"
    ".dir-locals.el"
    ".idea"
    ".tern-project"
    ".tern-port"

    # It's better to unpack these files and commit the raw source because
    "# git has its own built in compression methods."
    "*.7z"
    "*.jar"
    "*.rar"
    "*.zip"
    "*.gz"
    "*.bzip"
    "*.bz2"
    "*.xz"
    "*.lzma"
    "*.cab"
    "
    " #packing-only formats"
    "*.iso"
    "*.tar"

    ### Linux ###
    "*~"
    # temporary files which can be created if a process still has a handle open of a deleted file
    ".fuse_hidden*"
    # KDE directory preferences
    ".directory"
    # Linux trash folder which might appear on any partition or disk
    ".Trash-*"
    # .nfs files are created when an open file is removed but is still being accessed
    ".nfs*"

    ### macOS ###
    # General
    ".DS_Store"
    ".AppleDouble"
    ".LSOverride"
    # Icon must end with two \r
    "Icon"
    # Thumbnails
    "._*"
    # Files that might appear in the root of a volume
    ".DocumentRevisions-V100"
    ".fseventsd"
    ".Spotlight-V100"
    ".TemporaryItems"
    ".Trashes"
    ".VolumeIcon.icns"
    ".com.apple.timemachine.donotpresent"
    # Directories potentially created on remote AFP share
    ".AppleDB"
    ".AppleDesktop"
    "Network Trash Folder"
    "Temporary Items"
    ".apdisk"

    ### macOS Patch ###
    "# iCloud generated files"
    "*.icloud"

    ### Vim ###
    # Swap
    "[._]*.s[a-v][a-z]"
    "!*.svg  # comment out if you don't need vector files"
    "[._]*.sw[a-p]"
    "[._]s[a-rt-v][a-z]"
    "[._]ss[a-gi-z]"
    "[._]sw[a-p]"
    # Session
    "Session.vim"
    "Sessionx.vim"
    # Temporary
    ".netrwhist"
    # Auto-generated tag files
    "tags"
    # Persistent undo
    "[._]*.un~"
  ];
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
      default = false;
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
      userName = cfg.username;
      userEmail = cfg.email;
      diff-so-fancy = {
        enable = true;
      };
      ignores = gitIgnores;
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
      extraConfig = {
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

        format.signoff = cfg.signCommits;
        commit.gpgSign = cfg.signCommits;
        user.signingkey = config.feltnerm.programs.gpg.pubKey;
        gpg = {
          #format = "ssh";
          #ssh = {
          #  defaultKeyCommand = "${pkgs.openssh}/bin/ssh-add -L";
          #  programs = "${pkgs.openssh}/bin/ssh-keygen";
          #  #    # TODO
          #  #    # allowedSignersFile = cfg.allowedSignerFile;
          #};
        };
      };
    };
  };
}
#TODO
# - add script to clone into ~/code

