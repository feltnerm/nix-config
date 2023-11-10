## common configuration options shared between all modules
{...}: {
  imports = [
    ./feltnerm.nix
  ];
  config = {
    # Enable nix flakes
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };
}
