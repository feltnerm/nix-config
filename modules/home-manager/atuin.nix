{ config, lib, ... }:
{
  programs.atuin = lib.mkIf config.programs.atuin.enable {
    daemon.enable = lib.mkDefault true; # required for ZFS
    settings = {
      invert = true;
      inline_height = 36;
      search_mode = "skim";
      style = "compact";
      enter_accept = false; # do not immediately execute a command
      filter_mode_shell_up_key_binding = "directory"; # up-arrow searches current dir if it is a .git directory
      keymap_mode = "vim-normal";
    };
  };
}
