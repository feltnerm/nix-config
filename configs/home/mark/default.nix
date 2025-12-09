{
  inputs,
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
      # theme default now comes from flake-level feltnerm.theme via extraSpecialArgs
      # remove or override here only if you need per-home differences
      # theme = lib.mkDefault "catppuccin-mocha";
      yubikey.enable = true;
      developer = {
        enable = true;
        ai.enable = true;
        git = {
          username = "feltnerm";
          email = "feltner.mj@gmail.com";
        };
      };

      # Use YubiKey SSH key for Git signing
      ssh.signingKey = "~/.ssh/id_ed25519_sk.pub";
    };

    programs = {
      # FIXME
      git.settings.commit.gpgSign = false;
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
