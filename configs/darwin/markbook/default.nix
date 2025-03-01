{ pkgs, ... }:
{
  system.stateVersion = 5;

  services = {
    # TODO use instead of amethyst
    # yabai.enable = true;
    # skhd.enable = true;
  };

  homebrew = {
    enable = true;
    casks = [
      # tiling window manager
      # TODO replace with yabai
      "amethyst"

      # e-book manager
      "calibre"

      # Visual size
      "disk-inventory-x"

      # Dreams
      "electric-sheep"

      # Gdrive
      "google-drive"

      # 🦊
      "firefox"

      # block stuff
      "minecraft"

      # screen recorder and broadcaster
      "obs"

      # For Java
      "intellij-idea-ce"

      # VPN
      #"private-internet-access"

      # it's meh, but good visual editor
      "visual-studio-code"

      # VM mgmt
      "virtualbox"

      # media player
      "vlc"
    ];
  };

  # allow nix to manage fonts
  # FIXME fonts = lib.mkIf cfg.gui.fonts.enable {
  fonts = {
    packages = with pkgs; [
      # sans fonts
      comic-neue
      source-sans

      # monospace
      nerd-fonts.hack
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.blex-mono
    ];
  };
}
