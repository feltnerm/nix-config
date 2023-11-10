{
  config,
  lib,
  # outputs,
  ...
}: let
  cfg = config.feltnerm;
in {
  # docs
  options.feltnerm = {
    documentation = {
      enable = lib.mkOption {
        description = "Enable building documentation.";
        default = true;
      };
    };

    # locale
    locale = {
      timezone = lib.mkOption {
        description = "System timezone";
        default = "America/Chicago";
      };

      keymap = lib.mkOption {
        description = "System keymap";
        default = "us";
      };
    };
    # nix
    nix = {
      enableFlake = lib.mkOption {
        description = "Enable nix flake support";
        default = true;
      };

      allowedUsers = lib.mkOption {
        description = "Users to give access to nix to.";
        default = [];
      };

      trustedUsers = lib.mkOption {
        description = "Users to give enhanced access to nix to.";
        default = [];
      };
    };

    # gui
    gui = {
      enable = lib.mkOption {
        description = "Enable desktop GUI.";
        default = false;
      };

      # fonts
      fonts = {
        enable = lib.mkOption {
          description = "Enable pretty fonts.";
          default = false;
        };
      };
    };
  };

  config = {
    # documentation = lib.mkIf cfg.documentation.enable {
    #   enable = true;
    #   man = {
    #     enable = true;
    #   };
    #   info.enable = true;
    # };

    nix.settings.experimental-features = ["nix-command" "flakes"];

    # nixpkgs.overlays = builtins.attrValues outputs.overlays;
    # nixpkgs.config = {
    #   allowUnfree = lib.mkDefault true;
    #   allowBroken = lib.mkDefault false;
    # };

    programs.zsh.enable = true;
  };
}
