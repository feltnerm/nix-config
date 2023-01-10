{
  config,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./readline.nix
    ./ssh.nix
    ./tmux.nix
    ./wayland.nix
    ./zsh.nix
  ];
}
