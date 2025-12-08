/**
  A flake-parts module for configuring my hosts and users.
*/
{
  config,
  inputs,
  lib,
  ...
}:
let
  /**
    base modules to use
  */
  systemModule = import ./system.nix;

  /**
    Generate the configuration for users.
  */
  mkUsersConfig =
    users: userHomeFunction:
    builtins.mapAttrs (username: _userConf: {
      name = lib.mkDefault "${username}";
      home = lib.mkDefault (userHomeFunction username);
    }) users;

  /**
    Generate home-manager configuration for users.
  */
  mkHomeUsersConfig =
    users: userHomeFunction: homeManagerModule:
    builtins.mapAttrs (
      username: userConfig:
      let
        userHomeConfig = userConfig.home;
      in
      {
        imports = [
          homeManagerModule
        ]
        ++ userHomeConfig.modules;
        config = {
          home = {
            inherit username;
            homeDirectory = lib.mkDefault (userHomeFunction username);
          };
          # let home-manager install and manage itself
          programs.home-manager.enable = true;

          # allow unfree packages per HM user
          nixpkgs.config = {
            allowUnfree = true;
            #allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
          };
        };
      }
    ) users;

  /**
      Generic system builder to deduplicate platform-specific logic
  */
  mkSystemsGeneric =
    buildFn: hosts: baseModule: homeManagerModule: homeRoot: extraModules:
    builtins.mapAttrs (
      hostname: hostConfig:
      buildFn {
        inherit (hostConfig) system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          { _module.args = { inherit inputs hostname; }; }

          # shared modules
          systemModule
          baseModule

          # networking
          { networking.hostName = lib.mkDefault "${hostname}"; }

          # allow unfree packages for system builds
          {
            nixpkgs.config = {
              allowUnfree = true;
              #allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
            };
          }

          # users and groups
          {
            users.users = mkUsersConfig hostConfig.users (u: "${homeRoot}/${u}");
          }
          {
            users.groups = builtins.mapAttrs (_username: _userConf: { }) hostConfig.users;
          }
          {
            users.users = builtins.mapAttrs (_username: _userConf: {
              isNormalUser = lib.mkDefault true;
              createHome = lib.mkDefault true;
            }) hostConfig.users;
          }

          # home-manager
          (
            if homeRoot == "/Users" then
              inputs.home-manager.darwinModules.home-manager
            else
              inputs.home-manager.nixosModules.home-manager
          )
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit hostname inputs;
                inherit (hostConfig) system;
                feltnermTheme = config.feltnerm.theme;
              };
              users = mkHomeUsersConfig hostConfig.users (u: "${homeRoot}/${u}") homeManagerModule;
            };
          }
        ]
        ++ extraModules
        ++ hostConfig.modules;
      }
    ) hosts;

  /**
      Create nixos systems
  */
  mkNixosSystems =
    nixosHosts: nixosModule: homeManagerModule: extra:
    mkSystemsGeneric inputs.nixpkgs.lib.nixosSystem nixosHosts nixosModule homeManagerModule "/home" (
      [
        inputs.stylix.nixosModules.stylix
        inputs.agenix.nixosModules.default
        inputs.nixos-generators.nixosModules.all-formats
        inputs.nix-topology.nixosModules.default
      ]
      ++ extra
    );

  /**
      Create nix-darwin systems
  */
  mkDarwinSystems =
    darwinHosts: darwinModule: homeManagerModule:
    mkSystemsGeneric inputs.darwin.lib.darwinSystem darwinHosts darwinModule homeManagerModule "/Users"
      [
        inputs.stylix.darwinModules.stylix
        inputs.nix-homebrew.darwinModules.nix-homebrew
        inputs.agenix.darwinModules.default
      ];

  /**
        Create a home-manager home
  */
  mkHomeManagerHomes =
    pkgs: userHomes: homeManagerModule:
    builtins.mapAttrs (
      username: userConfig:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs username;
          feltnermTheme = config.feltnerm.theme;
        };
        modules = [
          { _module.args = { inherit inputs username; }; }

          # my modules
          homeManagerModule

          {
            home = {
              inherit username;
              homeDirectory = lib.mkDefault (
                if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}"
              );
            };
          }

          # allow unfree packages in HM evaluation
          {
            nixpkgs.config = {
              allowUnfree = true;
              #allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
            };
          }

          # default modules
          inputs.agenix.homeModules.default
        ]
        ++ userConfig.modules;
      }
    ) userHomes;

  /**
        Create nixvim configs
  */
in
{

  imports = [ ./options.nix ];

  config = {

    flake = {
      /**
        configs
      */
      darwinConfigurations =
        mkDarwinSystems config.feltnerm.darwin.hosts inputs.self.darwinModules.default
          inputs.self.homeModules.default;
      nixosConfigurations =
        (mkNixosSystems config.feltnerm.nixos.hosts inputs.self.nixosModules.default
          inputs.self.homeModules.default
          [ ]
        )
        // (mkNixosSystems config.feltnerm.nixos.vms inputs.self.nixosModules.default
          inputs.self.homeModules.default
          [ inputs.self.nixosModules.vm-base ]
        )
        // (mkNixosSystems config.feltnerm.nixos.livecds inputs.self.nixosModules.default
          inputs.self.homeModules.default
          [ inputs.self.nixosModules.live-iso ]
        )
        // (mkNixosSystems config.feltnerm.nixos.wsl inputs.self.nixosModules.default
          inputs.self.homeModules.default
          [ inputs.self.nixosModules.wsl-base ]
        );
    };

    perSystem =
      { pkgs, ... }:
      {
        /**
          home-manager
        */
        legacyPackages.homeConfigurations =
          mkHomeManagerHomes pkgs config.feltnerm.home.users
            inputs.self.homeModules.default;

        # nixvimConfigurations disabled: home-manager nixvim module is not compatible with evalNixvim
        # nixvimConfigurations =
        #   mkNixvimConfigs system config.feltnerm.nixvim.configs
        #     inputs.self.nixvimModules.default;
      };

  };

}
