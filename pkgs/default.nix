{ pkgs }:
{
  chuckscii = pkgs.callPackage ./chuckscii { };
  greet = pkgs.callPackage ./greet.nix { };
  nlsp = pkgs.callPackage ./nlsp.nix { };
  screensaver = pkgs.callPackage ./screensaver { };
  year-progress = pkgs.callPackage ./year-progress { };
}
