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
        ] ++ userHomeConfig.modules;
        config = {
          home = {
            inherit username;
            homeDirectory = lib.mkDefault (userHomeFunction username);
          };
          # let home-manager install and manage itself
          programs.home-manager.enable = true;
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

          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }

          # my modules
          systemModule
          nixosModule

          { nixpkgs.config.allowUnfree = lib.mkDefault true; }

          # networking
          { networking.hostName = lib.mkDefault "${hostname}"; }

          # users
          {
            users.users = mkUsersConfig hostConfig.users (u: "/home/${u}");
          }

          # user groups
          {
            users.users = builtins.mapAttrs (username: _userConf: {
              extraGroups = [ "${username}" ];
            }) hostConfig.users;
            users.groups = builtins.mapAttrs (_username: _userConf: { }) hostConfig.users;
          }

          # nixos user
          {
            users.users = builtins.mapAttrs (_username: _userConf: {
              isNormalUser = lib.mkDefault true;
              createHome = lib.mkDefault true;
            }) hostConfig.users;
          }

          # user modules
          {
            users.users = builtins.mapAttrs (_username: userConf: _: {
              imports = userConf.modules;
            }) hostConfig.users;
          }

          # home-manager
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
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

        ] ++ hostConfig.modules;
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
          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }
          systemModule
          darwinModule

          # nixpkgs
          { nixpkgs.config.allowUnfree = lib.mkDefault true; }

          # networking
          { networking.hostName = lib.mkDefault "${hostname}"; }

          # users
          {
            users.users = mkUsersConfig hostConfig.users (u: "/Users/${u}");
          }

          # home-manager
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
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
        ] ++ hostConfig.modules;
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
          {
            nix.settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
          }
          homeManagerModule

          { nixpkgs.config.allowUnfree = true; }

          {
            home = {
              inherit username;
              homeDirectory = lib.mkDefault (
                if pkgs.stdenv.isDarwin then "/Users/${username}" else "/home/${username}"
              );
            };
          }

          # default modules
          inputs.agenix.homeManagerModules.default
        ] ++ userConfig.modules;
      }
    ) userHomes;

  /**
        Create nixvim configs
  */
  mkNixvimConfigs =
    system: vimConfigs: nixvimModules:
    builtins.mapAttrs (
      _vimConfigName: vimConfig:
      inputs.nixvim.lib.evalNixvim {
        inherit system;
        extraSpecialArgs = { inherit system inputs; };
        modules = [
          nixvimModules
        ] ++ vimConfig.modules;
      }
    ) vimConfigs;
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
          inputs.self.homeManagerModules.default;
      nixosConfigurations =
        mkNixosSystems config.feltnerm.nixos.hosts inputs.self.nixosModules.default
          inputs.self.homeManagerModules.default;
    };

    perSystem =
      { system, pkgs, ... }:
      {
        /**
          home-manager
        */
        legacyPackages.homeConfigurations =
          mkHomeManagerHomes pkgs config.feltnerm.home.users
            inputs.self.homeManagerModules.default;

        nixvimConfigurations =
          mkNixvimConfigs system config.feltnerm.nixvim.configs
            inputs.self.nixvimModules.default;
      };

  };

}
