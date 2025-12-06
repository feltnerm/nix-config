_: {
  flake.overlays.default = final: prev: {
    # Re-export all packages from this flake as overlay attributes
    chuckscii = final.callPackage ../pkgs/chuckscii/package.nix { };
    greet = final.callPackage ../pkgs/greet/package.nix { };
    nlsp = final.callPackage ../pkgs/nlsp/package.nix { };
    screensaver = final.callPackage ../pkgs/screensaver/package.nix { };
    year-progress = final.callPackage ../pkgs/year-progress/package.nix { };
  };
}
