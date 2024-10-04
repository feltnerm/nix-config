{ inputs, ... }:
let
  inherit (inputs) self home-manager nixos-generators;
  inherit (self) outputs;

  user = import ./user.nix { inherit inputs; };
in
{
  mkNixosModule =
    {
      # The system's hostname. Required.
      hostname,
      # A list of users for this system. Required.
      users,
      #
      pkgs,
      # The system type.
      system ? "x86_64-linux",
      # The host-specific nix module.
      hostModule ? ./../conf/hosts + "/${hostname}" + /default.nix,
      # Any extra modules to load.
      extraModules ? [ ],
      # The default shell of the system.
      defaultShell ? "bashInteractive",
      # Any extra config for this system.
      systemConfig ? { },
      # Any users to configure with home-manager
      homeManagerUsers ? [ ],
      ...
    }:
    let
      baseModule = {
        imports = [ nixos-generators.nixosModules.all-formats ];
        config = {
          # set hostname of this machine
          networking.hostName = hostname;

          # by default, disable any non-enabled networking interface
          networking.useDHCP = false;

          users.defaultUserShell = pkgs."${defaultShell}";
        };
      };

      mkNixosUser = user.nixosUserFactory pkgs;
      userModules = map mkNixosUser users;

      useHomeManager = builtins.length homeManagerUsers > 0;
      homeManagerModules =
        if useHomeManager then
          [
            home-manager.nixosModules.home-manager
            {
              # home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "nixbak";
            }
          ]
        else
          [ ];

      homeManagerUserModules = builtins.map (
        homeManagerUser:
        let
          inherit (homeManagerUser) username;
          userConfig =
            if builtins.hasAttr "userConfig" homeManagerUser && builtins.isAttrs homeManagerUser.userConfig then
              homeManagerUser.userConfig
            else
              { };
          userModule =
            if builtins.hasAttr "userModule" homeManagerUser && builtins.isPath homeManagerUser.userModule then
              homeManagerUser.userModule
            else
              ./../conf/home + "/${username}" + /default.nix;
        in
        {
          home-manager.extraSpecialArgs = {
            inherit inputs outputs username;
          };
          # home-manager.users."${username}" = userConfig;
          home-manager.users."${username}" = {
            imports = [
              ../modules/home-manager
              userModule
            ];
            config = userConfig;
          };
        }
      ) homeManagerUsers;
    in
    {
      # inherit pkgs system;
      inherit system;
      specialArgs = {
        inherit
          inputs
          outputs
          hostname
          users
          systemConfig
          ;
      };
      modules =
        [
          # ../modules/common
          ../modules/nixos
          baseModule
        ]
        ++ homeManagerModules
        ++ extraModules
        ++ [
          systemConfig
          hostModule
        ]
        ++ userModules
        ++ homeManagerUserModules;
    };
}
