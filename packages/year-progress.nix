{pkgs, ...}: let
  name = "year-progress";
in
  pkgs.writeShellApplication {
    inherit name;
    text = builtins.readFile ./year-progress.sh;
  }
