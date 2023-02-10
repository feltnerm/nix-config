{pkgs}: {
  chuckscii = pkgs.callPackage ./chuckscii.nix {};
  greet = pkgs.callPackage ./greet.nix {};
  nlsp = pkgs.callPackage ./nlsp.nix {};
  screensaver = pkgs.callPackage ./screensaver.nix {};
  year-progress = pkgs.callPackage ./year-progress.nix {};
}
