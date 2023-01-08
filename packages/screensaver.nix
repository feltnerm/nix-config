{pkgs}: let
  name = "screensaver";
in
  pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = [pkgs.neofetch pkgs.fortune pkgs.cowsay];
    text = ''
      while true; do
          clear && \
          neofetch && \
          fortune | cowsay && \
          sleep 30
      done
    '';
  }
