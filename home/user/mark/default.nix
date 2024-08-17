{lib, ...}: {
  config = {
    feltnerm = {
      profiles.developer.enable = true;
      programs = {
        git = {
          username = "feltnerm";
          email = "feltner.mj@gmail.com";
          signCommits = lib.mkDefault false; # FIXME
        };

        gpg.pubKey = "390FE4873BBF0F96";

        neovim = {
          vimwiki = {
            enable = true;
            wikis = {
              "feltnerm" = {};
            };
          };
          ui.startify.extraConfig = ''
            let g:startify_header = system('chuckscii')
            let g:startify_custom_header =
              \ startify#center(split(startify_header, '\n')) +
              \ startify#center([""]) +
              \ startify#center(startify#fortune#boxed()) +
              \ startify#center([""]) +
              \ startify#center(split(system('date -R'), '\n')) +
              \ startify#center([""]) +
              \ startify#center(split(system('year-progress 100'), '\n'))
          '';
        };
      };
    };

    home = {};

    programs = {
      keychain = {
        enable = true;
        keys = ["id_ed25519_sk"];
      };
    };
  };
}
