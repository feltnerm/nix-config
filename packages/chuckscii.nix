{ pkgs, ... }:
let
  name = "chuckscii";
in
pkgs.writeShellApplication {
  inherit name;
  text = builtins.readFile ./chuckscii.sh;
}
