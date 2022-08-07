{
  mkShell,
  nix,
  home-manager,
  git,
  ...
}:
mkShell {
  nativeBuildInputs = [
    nix
    home-manager
    git

    # Para deploy
    # gnupg
    # age
    # deploy-rs
    # sops
  ];
}
