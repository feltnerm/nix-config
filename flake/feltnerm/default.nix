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
    Attempt to load a user module from ${cfgBase}/${hostname}/${userCfgBase}/${username}/default.nix or ${cfgBase}/${hostname}/${userCfgBase}/${username}.nix
  */
  loadUserModule =
    conventions: os: hostname: userCfgBase: username:
    let
      defaultPath = conventions.configsPath + "/${os}/${hostname}/${userCfgBase}/${username}/default.nix";
      path = conventions.configsPath + "/${os}/${hostname}/${userCfgBase}/${username}.nix";
    in
    if builtins.pathExists defaultPath then
      defaultPath
    else if builtins.pathExists path then
      path
    else
      throw "No user config found for user: ${username}";

  /**
    Attempt to load a user home module from ${cfgBase}/${hostname}/${homeCfgBase}/${username}/default.nix or ${cfgBase}/${hostname}/${userCfgBase}/${username}.nix
  */
  loadUserHomeModule =
    conventions: os: hostname: homeCfgBase: username:
    let
      defaultPath = conventions.configsPath + "/${os}/${hostname}/${homeCfgBase}/${username}";
      path = conventions.configsPath + "/${os}/${hostname}/${homeCfgBase}/${username}.nix";
    in
    if builtins.pathExists defaultPath then
      defaultPath
    else if builtins.pathExists path then
      path
    else
      throw "No user home config found for: ${username}@${hostname} (${os})";

  /**
    Attempt to load a host module from ${cfgBase}/${hostname}/default.nix or
  */
  loadHostModule =
    conventions: os: hostname:
    let
      defaultPath = conventions.configsPath + "/${os}/${hostname}";
      path = conventions.configsPath + "/${os}/${hostname}/${hostname}.nix";
    in
    if builtins.pathExists defaultPath then
      defaultPath
    else if builtins.pathExists path then
      path
    else
      throw "No host config found for: ${hostname}";

  /**
    Attempt to load a home module from ${cfgBase}/home/default.nix or
  */
  loadHomeModule =
    conventions: username:
    let
      defaultPath = conventions.configsPath + "/${conventions.homeConfigsDirName}/${username}";
      path = conventions.configsPath + "/${conventions.homeConfigsDirName}/${username}/${username}.nix";
    in
    if builtins.pathExists defaultPath then
      defaultPath
    else if builtins.pathExists path then
      path
    else
      throw "No home config found for: ${username}";

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
    os: hostname: users: userHomeFunction: homeManagerModule:
    builtins.mapAttrs (
      username: userConfig:
      let
        userHomeConfig = userConfig.home;
        # conventionally loaded user home module
        homeModule = loadHomeModule config.feltnerm.conventions username;
        userHomeModule =
          loadUserHomeModule config.feltnerm.conventions os hostname
            config.feltnerm.conventions.userHomeConfigsDirName
            username;
      in
      {
        imports = [
          homeManagerModule
          homeModule
          userHomeModule
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
    Generic ../system builder to deduplicate platform-specific logic
  */
  mkSystemsGeneric =
    os: buildFn: hosts: baseModule: homeManagerModule: extraModules:
    builtins.mapAttrs (
      hostname: hostConfig:
      let
        # of course apple has to be weird
        homeRoot = if os == "darwin" then "/Users" else "/home";
        # conventionally loaded host module
        hostModule = loadHostModule config.feltnerm.conventions os hostname;
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
          hostModule

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

          # autoload user modules based on convention
          {
            imports = builtins.attrValues (
              builtins.mapAttrs (
                username: _userConf:
                loadUserModule config.feltnerm.conventions os hostname
                  config.feltnerm.conventions.userConfigsDirName
                  username
              ) hostConfig.users
            );
          }

          # user modules
          {
            imports = builtins.concatLists (
              builtins.attrValues (builtins.mapAttrs (_username: userConf: userConf.modules) hostConfig.users)
            );
          }

          # home-manager (darwin vs nixos)
          (
            if os == "darwin" then
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
              users = mkHomeUsersConfig os hostname hostConfig.users (u: "${homeRoot}/${u}") homeManagerModule;
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
    mkSystemsGeneric "nixos" inputs.nixpkgs.lib.nixosSystem nixosHosts nixosModule homeManagerModule (
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
    mkSystemsGeneric "darwin" inputs.darwin.lib.darwinSystem darwinHosts darwinModule homeManagerModule
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
      let
        userHomeModule = loadHomeModule config.feltnerm.conventions username;
      in
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
          userHomeModule

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
