{pkgs}:
pkgs.writeShellApplication {
  name = "screensaver";
  runtimeInputs = [pkgs.neofetch pkgs.fortune pkgs.cowsay];
  text = builtins.readFile ./screensaver.sh;
}
