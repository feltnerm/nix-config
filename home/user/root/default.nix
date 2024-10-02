{pkgs, ...}: {
  imports = [
    ../../../modules/nix
    ../../modules
  ];

  config = {
    feltnerm = {
      git.enable = true;
      htop.enable = true;
      neofetch.enable = true;
      nvim.enable = true;
      zsh.enable = true;
    };

    home = {
      # Software
      packages = with pkgs; [
        # Utils
        any-nix-shell
      ];
    };
  };
}
