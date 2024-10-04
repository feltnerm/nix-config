{ pkgs, ... }:
let
  name = "year-progress";
in
pkgs.writeShellApplication {
  inherit name;
  runtimeInputs = [
    pkgs.bc
  ];
  text = builtins.readFile ./year-progress.sh;
}
