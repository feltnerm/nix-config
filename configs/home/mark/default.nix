{
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.nixvim.homeModules.nixvim
    inputs.stylix.homeModules.stylix
  ];

  config = {
    feltnerm = {
      enable = true;
      theme = lib.mkDefault "catppuccin-mocha";
      developer = {
        enable = true;
        ai.enable = true;
        git = {
          username = "feltnerm";
          email = "feltner.mj@gmail.com";
        };
      };
    };

    stylix = {
      enable = true;
      enableReleaseChecks = lib.mkDefault false;
    };

    programs = {
      keychain = {
        keys = [ "id_ed25519_sk" ];
      };
      nixvim = _: {
        # imports = [inputs.self.nixvimConfigurations.packages];
        config = {
          enable = true;
        };
      };
    };

    home = {
      stateVersion = "25.05";
      # FIXME use my nixvim distribution (https://stylix.danth.me/configuration.html#standalone-nixvim)
      # packages = [ inputs.self.packages.${system}.feltnerm-nvim ];
    };

  };
}
