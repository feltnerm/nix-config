_: {
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "feltnerm-dev";
        NIX_CONFIG = "experimental-features = nix-command flakes";
        nativeBuildInputs = with pkgs; [
          nix
          git
          treefmt
          gitlint
          gnupg
          home-manager
        ];
        shellHook = ''
          echo "Welcome to feltnerm-dev"
          echo "Commands:"
          echo "  nix fmt            # format the repo"
          echo "  nix flake check    # run flake checks"
          echo "  nix flake update   # update inputs"
          echo "  home-manager switch --flake .#mark"
        '';
      };
    };
}
