{pkgs}: let
  name = "screensaver";
in
  pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [pkgs.neofetch pkgs.fortune pkgs.cowsay];
    text = builtins.readFile ./screensaver.sh;
  }
