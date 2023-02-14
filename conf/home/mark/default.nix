{
  config,
  lib,
  ...
}: {
  config = {
    home = {
      stateVersion = "22.05";
      homeDirectory = lib.mkDefault "/home/mark";

      # extra packages
      packages = [];

      # extra directories to add to $PATH
      sessionPath = [];

      # extra environment variables
      sessionVariables = {
        DROPBOX = "$HOME/Dropbox";

        # FIXME required for GUI/Wayland
        #MOZ_ENABLE_WAYLAND = 1;
        #XDG_CURRENT_DESKTOP = "sway";
      };
    };

    programs = {
      keychain = {
        enable = true;
        keys = ["id_ed25519_sk"];
      };
    };

    feltnerm = {
      config.code.enableCodeDir = true;
      cli = {
        enable = true;
        neovim.enable = true;
      };
      programs = {
        git = {
          enable = true;
          username = "feltnerm";
          # TODO better public email
          email = "feltner.mj@gmail.com";
          signCommits = true;
        };

        gpg = {
          pubKey = "390FE4873BBF0F96";
          enable = true;
        };
      };
    };
  };
}
