_: {
  config.den.aspects.features.provides.home-wsl-vars = {
    homeManager = {
      home.sessionVariables = {
        # CODE_HOME is set via feltnerm.developer.codeHome (defaults to ~/code)
        WINDOWS = "/mnt/c";
        WINHOME = "/mnt/c/Users/mark";
      };

      programs.zsh.shellAliases = {
        winhome = "cd $WINHOME";
        desktop = "cd $WINHOME/Desktop";
        downloads = "cd $WINHOME/Downloads";
        documents = "cd $WINHOME/Documents";
        explorer = "explorer.exe .";
      };
    };
  };
}
