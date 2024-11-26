{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
  ];
  perSystem = _: {
    treefmt = {
      programs = {
        deadnix.enable = true;
        mdsh.enable = true;
        nixfmt.enable = true;
        shellcheck.enable = true;
        shfmt.enable = true;
        statix.enable = true;
      };
      settings = {
        global.excludes = [
          "*.editorconfig"
          "*.envrc"
          "*.gitconfig"
          "*.git-blame-ignore-revs"
          "*.gitignore"
          "*.gitattributes"
          "*.luacheckrc"
          "*CODEOWNERS"
          "*LICENSE"
          "*flake.lock"
          "justfile"
          "assets/*"
        ];
      };
    };
  };
}
