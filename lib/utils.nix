{ inputs, ... }:
let
  inherit (inputs) nixpkgs;
  inherit (nixpkgs.lib) genAttrs;
  inherit (builtins) elemAt match;
in
rec {
  getUsername = string: elemAt (match "(.*)@(.*)" string) 0;
  getHostname = string: elemAt (match "(.*)@(.*)" string) 1;

  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "i686-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  forAllSystems = genAttrs systems;
}
