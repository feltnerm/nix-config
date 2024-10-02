{pkgs}: {
  default = pkgs.neofetch;
  chuckscii = pkgs.callPackage ./chuckscii {};
  greet = pkgs.callPackage ./greet {};
  nix-format-feltnerm = pkgs.callPackage ./nix-format-feltnerm {};
  nlsp = pkgs.callPackage ./nlsp {};
  screensaver = pkgs.callPackage ./screensaver {};
  year-progress = pkgs.callPackage ./year-progress {};
}
