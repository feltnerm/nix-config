{
  self,
  inputs,
  stateVersion,
  stateVersionDarwin,
  ...
}: let
  homeConfiguration = "${self}/home";
  hostConfiguration = "${self}/system";
  homeProfiles = "${homeConfiguration}/profiles";
  homeModules = "${homeConfiguration}/modules";
  hostModules = "${hostConfiguration}/modules";
  generalModules = "${self}/modules";
in {
  # create a home-manager configuration
  mkHome = {
    username ? "mark",
    hostname ? "nixos",
    platform ? "x86_64-linux",
    extraConfig ? {},
  }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.${platform};
      extraSpecialArgs = {
        inherit inputs self homeProfiles homeModules generalModules username hostname platform stateVersion extraConfig;

        modules = [
          "${homeConfiguration}"
        ];
      };
    };

  # create a nixos host
  # TODO optional home-manager
  mkHost = {
    hostname ? "nixos",
    username ? "mark",
    platform ? "x86_64-linux",
    extraConfig ? {},
  }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs self homeProfiles homeModules hostModules generalModules hostname username platform stateVersion extraConfig;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        "${hostConfiguration}"
        "${homeConfiguration}"
        extraConfig
      ];
    };

  # create a darwin host
  mkHostDarwin = {
    hostname ? "nix-darwin",
    platform ? "x86_64-darwin",
    extraConfig ? {},
  }:
    inputs.darwin.lib.darwinSystem {
      specialArgs = {
        inherit
          inputs
          self
          #homeModules
          
          hostModules
          generalModules
          hostname
          #username
          
          platform
          stateVersionDarwin
          extraConfig
          ;
      };

      modules = [
        # inputs.home-manager.darwinModules.home-manager
        "${hostConfiguration}"
        # "${homeConfiguration}"
        # extraConfig
      ];
    };
}
