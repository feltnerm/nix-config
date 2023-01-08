{pkgs}: {
  greet = pkgs.callPackage ./greet.nix {};
  nlsp = pkgs.callPackage ./nlsp.nix {};
  screensaver = pkgs.callPackage ./screensaver.nix {};
}
