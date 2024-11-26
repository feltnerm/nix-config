{ pkgs }:
let
  name = "greet";
in
pkgs.writeShellApplication {
  inherit name;
  runtimeInputs = [
    pkgs.fortune
    pkgs.cowsay
  ];
  text = "fortune | cowsay -W 80";
}
