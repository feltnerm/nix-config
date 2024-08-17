{ inputs, pkgs, ... }: {
  config = {

    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [
      home-manager
      neovim
      vim
    ];

    # FIXME
    # feltnerm = {
    #   fonts.enable = true;
    # };

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

    services.nix-daemon.enable = true;
    system.configurationRevision = inputs.rev or inputs.dirtyRev or null;
  };
}
