{
  lib,
  outputs,
  ...
}:
{
  # shared nixpkgs settings; if set here, config cannot be changed in flake.nix
  nixpkgs = {
    # add any custom overlays defined in `outputs.overlays`
    overlays = if (outputs ? "overlays") then builtins.attrValues outputs.overlays else [ ];
    config = {
      allowUnfree = lib.mkDefault true;
      allowBroken = lib.mkDefault false;
    };
  };
}
