{pkgs, ...}:
pkgs.writeShellApplication {
  name = "year-progress";
  runtimeInputs = [
    pkgs.bc
  ];
  text = builtins.readFile ./year-progress.sh;
}
