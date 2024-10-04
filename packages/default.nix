{ pkgs }:
{
  chuckscii = pkgs.callPackage ./chuckscii.nix { };
  docs = pkgs.callPackage ./docs.nix { };
  greet = pkgs.callPackage ./greet.nix { };
  nix-format-feltnerm = pkgs.callPackage ./nix-format-feltnerm.nix { };
  nlsp = pkgs.callPackage ./nlsp.nix { };
  screensaver = pkgs.callPackage ./screensaver.nix { };
  year-progress = pkgs.callPackage ./year-progress.nix { };
}
