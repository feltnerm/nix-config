{pkgs}:
pkgs.writeShellApplication {
  name = "greet";
  runtimeInputs = [pkgs.fortune pkgs.cowsay];
  text = "fortune | cowsay -W 80";
}
