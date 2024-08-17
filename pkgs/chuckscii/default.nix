{pkgs, ...}:
pkgs.writeShellApplication {
  name = "chuckscii";
  text = builtins.readFile ./chuckscii.sh;
}
