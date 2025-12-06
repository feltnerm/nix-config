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

          # allow unfree packages in Home Manager when using local pkgs
          nixpkgs.config.allowUnfree = lib.mkDefault true;
        };
      }
    ) users;

  /**
      Create nixos systems
  */
  mkNixosSystems =
    nixosHosts: nixosModule: homeManagerModule:
    builtins.mapAttrs (
      hostname: hostConfig:
      inputs.nixpkgs.lib.nixosSystem {
        inherit (hostConfig) system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          { _module.args = { inherit inputs hostname; }; }

          # my modules
          systemModule
          nixosModule

          # networking
          { networking.hostName = lib.mkDefault "${hostname}"; }

          # users
          {
            users.users = mkUsersConfig hostConfig.users (u: "/home/${u}");
          }

          # ensure each user has a group named after them
          {
            users.groups = builtins.mapAttrs (_username: _userConf: { }) hostConfig.users;
          }

          # nixos user
          {
            users.users = builtins.mapAttrs (_username: _userConf: {
              isNormalUser = lib.mkDefault true;
              createHome = lib.mkDefault true;
            }) hostConfig.users;
          }

          # home-manager
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit hostname inputs;
              };
              users = mkHomeUsersConfig hostConfig.users (u: "/home/${u}") homeManagerModule;
            };
          }

          # default modules
          inputs.agenix.nixosModules.default
          inputs.nixos-generators.nixosModules.all-formats
          inputs.nix-topology.nixosModules.default
          # FIXME facter
          # inputs.nixos-facter-modules.nixosModules.facter
          # { config.facter.reportPath = "${localFlake}/configs/nixos/${hostname}/facter.json"; }

        ]
        ++ hostConfig.modules;
      }
    ) nixosHosts;

  /**
      Create nix-darwin systems
  */
  mkDarwinSystems =
    darwinHosts: darwinModule: homeManagerModule:
    builtins.mapAttrs (
      hostname: hostConfig:
      inputs.darwin.lib.darwinSystem {
        inherit (hostConfig) system;
        specialArgs = {
          inherit inputs hostname;
        };
        modules = [
          { _module.args = { inherit inputs hostname; }; }

          # my modules
          systemModule
          darwinModule

          # networking
          { networking.hostName = lib.mkDefault "${hostname}"; }

          # users
          {
            users.users = mkUsersConfig hostConfig.users (u: "/Users/${u}");
          }

          # nix-homebrew
          inputs.nix-homebrew.darwinModules.nix-homebrew

          # home-manager
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = false;
              useUserPackages = true;
              extraSpecialArgs = {
                inherit (hostConfig) system;
                inherit
                  hostname
                  inputs
                  ;
              };
              users = mkHomeUsersConfig hostConfig.users (u: "/Users/${u}") homeManagerModule;
            };
          }

          # other included modules
          inputs.agenix.darwinModules.default
        ]
        ++ hostConfig.modules;
      }
    ) darwinHosts;

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
        mkNixosSystems config.feltnerm.nixos.hosts inputs.self.nixosModules.default
          inputs.self.homeModules.default;
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
