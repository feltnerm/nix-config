## common configuration options shared between all modules
{lib, ...}: {
  imports = [./nixpkgs.nix];
  options.feltnerm = {
    # docs
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

      locale = lib.mkOption {
        description = "Locale for the system.";
        default = "en_US.UTF-8";
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
    # Enable nix flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
