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
      profiles.developer.enable = true;
      programs = {
        git = {
          username = "feltnerm";
          # TODO better public email
          email = "feltner.mj@gmail.com";
          # FIXME get commit signing setup working again
          signCommits = false;
        };

        gpg.pubKey = "390FE4873BBF0F96";
      };
    };
  };
}
