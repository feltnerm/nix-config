_:
let
  inventory = {
    mark.systems = [
      "x86_64-linux" # exported as homeConfigurations."mark-x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

  homeFor = user: system: {
    inherit system;
    intoAttr = [
      "den"
      "homeConfigurations"
      "${user}-${system}"
    ];
  };

  mkHomesForSystem = system: {
    name = system;
    value = {
      mark = homeFor "mark" system;
    };
  };
in
{
  den.homes = builtins.listToAttrs (builtins.map mkHomesForSystem inventory.mark.systems);
}
