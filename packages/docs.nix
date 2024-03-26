# eval option docs via https://bmcgee.ie/posts/2023/03/til-how-to-generate-nixos-module-docs/
{
  pkgs,
  lib,
  runCommand,
  nixosOptionsDoc,
  ...
}: let
  options-doc = let
    # evaluate our options
    eval = lib.evalModules {
      specialArgs = {inherit pkgs;};
      modules = [
        {_module.check = false;}
        ../modules/default.nix
      ];
    };
    # generate our docs
    optionsDoc = nixosOptionsDoc {
      inherit (eval) options;
    };
  in
    # create a derivation for capturing the markdown output
    runCommand "options-doc.md" {} ''
      cat ${optionsDoc.optionsCommonMark} >> $out
    '';

  feltnerm-mkdocs = pkgs.writeShellApplication {
    name = "feltnerm-mkdocs";
    runtimeInputs = [
      pkgs.mkdocs
      pkgs.python310Packages.pygments
    ];
    text = ''
      ${pkgs.mkdocs}/bin/mkdocs build --clean
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    src = ./..;
    name = "feltnerm-mkdocs";

    buildInput = [options-doc];

    nativeBuildInputs = [
      feltnerm-mkdocs
    ];

    buildPhase = ''
      mkdir -p "docs"
      ln -sf ${options-doc} "./docs/nixos-options.md"
      ${feltnerm-mkdocs}/bin/feltnerm-mkdocs build
    '';

    installPhase = ''
      mv site $out
    '';

    # passthru.serve = pkgs.writeShellScriptBin "serve" ''
    #     set -euo pipefail

    #     # create link to nixos markdown options reference
    #     rm -f "docs/*.md"
    #     ln -sf ${options-doc}/* docs/

    #     ${pkgs.mkdocs}/bin/mkdocs serve
    # '';
  }
