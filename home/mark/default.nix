{
  config,
  lib,
  ...
}: {
  imports = [./cli ./neovim];

  config = {
    feltnerm = {
      config.code.enableCodeDir = true;
      programs = {
        git = {
          enable = lib.mkDefault true;
          username = lib.mkDefault "feltnerm";
          # TODO better public email
          email = lib.mkDefault "feltner.mj@gmail.com";
          signCommits = lib.mkDefault true;
        };

        gpg = {
          pubKey = lib.mkDefault "3BBF0F96";
          enable = lib.mkDefault true;
        };
      };
    };

    programs = {
      keychain = {
        enable = lib.mkDefault true;
        keys = lib.mkDefault ["id_ed25519_sk"];
      };
    };

    home = {
      stateVersion = "22.05";

      packages = [];

      # extra directories to add to $PATH
      sessionPath = [];

      sessionVariables = {
        DROPBOX = "$HOME/Dropbox";

        # FIXME required for GUI/Wayland
        #MOZ_ENABLE_WAYLAND = 1;
        #XDG_CURRENT_DESKTOP = "sway";
      };
    };
  };
}
