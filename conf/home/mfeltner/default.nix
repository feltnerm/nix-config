{config, ...}: {
  config = {
    home = {
      stateVersion = "22.05";
      homeDirectory = "/Users/mfeltner";
      sessionVariables = {
        # hack to use corretto @ work
        # `/usr/libexec/java_home -v 1.8`
        JAVA_HOME = "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home";
      };
    };

    programs.keychain = {
      enable = true;
      keys = ["id_ecdsa_sk"];
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
          email = "mark.feltner@acquia.com";
          username = "feltnerm";
        };
        gpg = {
          enable = true;
          pubKey = "FA9E3ABE6B2DF6521D541921CAA87B6562729B49";
        };
      };
      programs.neovim.ui.startify.extraConfig = ''
        let g:startify_custom_header =
          \ startify#center(["                                    "]) +
          \ startify#center(["      -*++=  -*++-  +*++++++*=      "]) +
          \ startify#center(["      :#@@@+ :%@@@= =@@@@@@@%:      "]) +
          \ startify#center(["        *@@@*  #@@@+ -@@@@@*        "]) +
          \ startify#center(["         *@@@#  #@@@* :%@@=         "]) +
          \ startify#center(["          +@@@#  *@@@* :*-          "]) +
          \ startify#center(["           =@@@%: +@@@#             "]) +
          \ startify#center(["            =@@@=  +@@#:            "]) +
          \ startify#center(["             -#-    =+              "]) +
          \ startify#center(["                                    "]) +
          \ startify#center([""]) +
          \ startify#center(startify#fortune#boxed()) +
          \ startify#center([""]) +
          \ startify#center(split(system('date -R'), '\n')) +
          \ startify#center([""]) +
          \ startify#center(split(system('year-progress 100'), '\n'))
      '';
    };
  };
}
