{
  self,
  darwinModules,
  hostname,
  pkgs,
  ...
}: let
  machineModules = "${self}/system/machine/${hostname}/modules";
in {
  imports = [
    "${darwinModules}"
    "${machineModules}"
  ];

  config = {
    feltnerm = {
      darwin = {
        enable = true;
        fonts.enable = true;
        homebrew.enable = true;
        security.enable = true;
        users.enable = true;
      };
      nix.enable = true;

      # docs.enable = true;
      # environment.enable = true;
      # FIXME
      # fonts.enable = true;
      #locale.enable = true;

      # programs = {
      #   enable = true;
      #   gnupg.enable = true;
      #   hm.enable = true;
      # };

      #security.enable = true;
      #users.enable = true;
    };

    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
      home-manager
      neovim
      vim
    ];

    services = {
      # TODO
      # yabai.enable = true;
      # skhd.enable = true;
    };

    homebrew.enable = true;
    homebrew.casks = [
      # terminal
      "alacritty"

      # tiling window manager
      # TODO replace with yabai
      "amethyst"

      # stop from sleeping
      "caffeine"

      # e-book manager
      "calibre"

      # hide status bar icons
      "dozer"

      # Visual size
      "disk-inventory-x"

      # Dreams
      "electric-sheep"

      # godot engine
      "godot"

      # Gdrive
      "google-drive"

      # 🦊
      "firefox"

      # block stuff
      "minecraft"

      # screen recorder and broadcaster
      "obs"

      # remote fs gui
      "cyberduck"

      # http request editor
      "insomnia"

      # For Java
      "intellij-idea-ce"

      # sql gui
      "sequel-ace"

      # VPN
      "tunnelblick"
      "private-internet-access"

      # it's meh, but good visual editor
      "visual-studio-code"

      # VM mgmt
      "vagrant"
      "virtualbox"

      # media player
      "vlc"
    ];
  };
}
