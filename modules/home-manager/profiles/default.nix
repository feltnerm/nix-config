{ lib, ... }:
{
  imports = [
    ./developer.nix
    ./gui.nix
    ./minimal.nix
  ];

  # Define profiles -- which are collections of implemented options -- here
  options.feltnerm.profiles = {
    # TODO
    headless = {
      enable = lib.mkOption {
        description = "Enable the headless profile which adds packages suitable for a headless system.";
        default = false;
      };
    };

    # TODO make this the default?
    minimal = {
      enable = lib.mkOption {
        description = "Enable the minimal profile which adds a baseline system suitable for a user.";
        default = false;
      };
    };

    developer = {
      # TODO add enables for different platforms, languages, and toolchains?
      enable = lib.mkOption {
        description = "Enable the developer profile whichs adds a ton of development tools.";
        default = false;
      };

      # languages = [
      # # nodejs = {};
      # # python = {};
      # # java = {};
      # ];
    };

    gui = {
      enable = lib.mkOption {
        description = "Add a pre-customized GUI to the (linux-based) system.";
        default = false;
      };
    };
  };
}
