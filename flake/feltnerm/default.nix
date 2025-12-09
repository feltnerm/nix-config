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
            allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
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
      let
        # Make platform checks explicit and readable
        isDarwin = homeRoot == "/Users";
      in
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
              allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
            };
          }

          # users and groups
          {
            users.users = mkUsersConfig hostConfig.users (u: "${homeRoot}/${u}");
          }
          {
            users.groups = builtins.mapAttrs (_username: _userConf: { name = _username; }) hostConfig.users;
          }
          {
            users.users = builtins.mapAttrs (_username: _userConf: (_userConf.attrs or { })) hostConfig.users;
          }

          # home-manager (darwin vs nixos)
          (
            if isDarwin then
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
    let
      conv = config.feltnerm.conventions;
      cfgBase = builtins.toString conv.configsPath;
      homeBase = builtins.toString conv.homeConfigsPath;

      # applyConventions
      # - derives conventional module paths for hosts, users, and homes
      # - host module:   ${cfgBase}/${hostname}
      # - user module:   ${cfgBase}/${hostname}/user/${username}.nix
      # - home modules:  ${homeBase}/${username} and ${cfgBase}/${hostname}/home/${username}.nix
      # - merges explicit modules/attrs from configuration
      applyConventions =
        hostAttrs:
        lib.mapAttrs (
          hostname: hostCfg:
          let
            # Require hosts to explicitly define users; if omitted, no users are configured
            users' = hostCfg.users or { };

            # For each user, append convention-based modules to any explicitly provided ones
            usersWithDefaults = lib.mapAttrs (
              username: userCfg:
              let
                hc = userCfg.home or { };
                homeModulesDefault = [
                  (homeBase + "/" + username)
                  (cfgBase + "/" + hostname + "/home/" + username + ".nix")
                ];
                userModulesDefault = [ (cfgBase + "/" + hostname + "/user/" + username + ".nix") ];
              in
              {
                modules = (userCfg.modules or [ ]) ++ userModulesDefault;
                home.modules = (hc.modules or [ ]) ++ homeModulesDefault;
                attrs = (userCfg.attrs or { }) // {
                  group = username;
                };
              }
            ) users';
          in
          {
            inherit (hostCfg) system;
            # Always include the conventional host module path
            modules = (hostCfg.modules or [ ]) ++ [ (cfgBase + "/" + hostname) ];
            users = usersWithDefaults;
          }
        ) hostAttrs;
    in
    mkSystemsGeneric inputs.nixpkgs.lib.nixosSystem (applyConventions nixosHosts) nixosModule
      homeManagerModule
      "/home"
      (
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
              allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "unrar" ];
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
