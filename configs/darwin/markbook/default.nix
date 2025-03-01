{ pkgs, ... }:
{
  system.stateVersion = 5;

  services.yabai.enable = true;
  services.skhd.enable = true;

  homebrew = {
    enable = true;
    casks = [
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

      # terminal emulator
      "iterm2"

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
