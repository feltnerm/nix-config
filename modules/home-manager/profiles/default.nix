{lib, ...}: {
  imports = [
    ./developer.nix
    ./gui.nix
    ./minimal.nix
  ];

  # Define profiles -- which are collections of implemented options -- here

  options.feltnerm.profiles = {
    developer = {
      # TODO add enables for different platforms, languages, and toolchains?
      enable = lib.mkOption {
        description = "Enable the developer profile whichs adds a ton of development tools.";
        default = false;
      };
    };

    # TODO make this the default?
    minimal = {
      enable = lib.mkOption {
        description = "Enable the minimal profile which adds a baseline system.";
        default = false;
      };
    };

    gui = {
      enable = lib.mkOption {
        description = "Add a pre-customized GUI to the (linux-based) system.";
        default = false;
      };
    };
  };
}
