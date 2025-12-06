# Deprecated: use pkgs/greet/package.nix
# Keeping stub for backward compatibility if referenced elsewhere.
{ pkgs }: import ./greet/package.nix { inherit pkgs; }
