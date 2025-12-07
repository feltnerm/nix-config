# markbook (MacBook Pro 13" Late 2013)

## Tweaks
- HiDPI scaling (Hyprland):
  ```nix
  # Example in configs/nixos/markbook/home/mark.nix
  wayland.windowManager.hyprland.settings = {
    monitor = "eDP-1,preferred,auto,2"; # e.g., 2x on Retina
  };
  ```
- Function keys default (Apple keyboard):
  ```nix
  # Add in configs/nixos/markbook/hardware.nix or default.nix
  boot.kernelParams = [ "hid_apple.fnmode=2" ];
  ```
- Power tuning:
  ```bash
  sudo powertop --auto-tune
  ```

## Install Shortcut
Follow `configs/nixos/README.md` for partitioning and base steps. Then install:
```bash
cd /mnt
sudo git clone https://github.com/feltnerm/nix-config
cd nix-config
sudo nixos-install --flake .#markbook
```
