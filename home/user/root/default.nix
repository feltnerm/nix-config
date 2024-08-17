{pkgs, ...}: {
  home = {
    # Software
    packages = with pkgs; [
      # Utils
      any-nix-shell
    ];
  };

  imports = [
    ../../../modules/nix
    ../../modules
  ];

  feltnerm = {
    git.enable = true;
    htop.enable = true;
    neofetch.enable = true;
    nvim.enable = true;
    zsh.enable = true;

    nix-config = {
      enable = true;
      useNixPackageManagerConfig = false;
    };
  };
}
