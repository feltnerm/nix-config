{pkgs, ...}: {
  programs.home-manager.enable = true;

  home = {
    username = "test";
    stateVersion = "24.11";

    # Software
    packages = with pkgs; [
      # Utils
      any-nix-shell
    ];
  };
}
