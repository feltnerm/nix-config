{ config, ... }:
{
  # WSL-specific environment conveniences
  home.sessionVariables = {
    CODE_HOME = "${config.home.homeDirectory}/code";
    WINDOWS = "/mnt/c";
    WINHOME = "/mnt/c/Users/mark";
  };

  programs.zsh = {
    shellAliases = {
      winhome = "cd $WINHOME";
      desktop = "cd $WINHOME/Desktop";
      downloads = "cd $WINHOME/Downloads";
      documents = "cd $WINHOME/Documents";
      explorer = "explorer.exe .";
    };
  };
}
