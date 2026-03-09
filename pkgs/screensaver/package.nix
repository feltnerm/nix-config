{ pkgs }:
let
  name = "screensaver";
in
pkgs.writeShellApplication {
  inherit name;
  runtimeInputs = [
    pkgs.fastfetch
    pkgs.fortune
    pkgs.cowsay
  ];
  text = builtins.readFile ./screensaver.sh;
}
