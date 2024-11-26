{
  inputs,
  ...
}:
{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    inputs.stylix.homeManagerModules.stylix
  ];

  config = {
    feltnerm = {
      enable = true;
      theme = "gruvbox-dark-hard";
      developer = {
        enable = true;
        git = {
          username = "feltnerm";
          email = "feltner.mj@gmail.com";
        };
      };
    };

    stylix = {
      enable = true;
    };

    programs = {
      nix-index.enable = true;
      nixvim = _: {
        # imports = [inputs.self.nixvimConfigurations.packages];
        config = {
          enable = true;
          plugins = {
            lsp.enable = true;
            blink-cmp.enable = true;
          };
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
