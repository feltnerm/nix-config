{ lib, ... }:
let
  hostInventory = import ./inventory.nix;

  mkHost = name: {
    ${name} = {
      users.mark = { };
      intoAttr = [
        "den"
        "nixosConfigurations"
        name
      ];
    };
  };

  hostNames = builtins.concatLists (
    builtins.map builtins.attrNames (builtins.attrValues hostInventory)
  );
in
{
  den.hosts.x86_64-linux = lib.mkMerge (builtins.map mkHost hostNames);
}
