# Markbook (MacBook Pro 13" Late 2013) — Install Guide

This guide installs NixOS using the `markbook` host configuration.

## Hardware
- Model: MacBook Pro 13" Late 2013 (MacBookPro11,1)
- CPU: Intel i7-4558U (Haswell)
- GPU: Intel Iris 5100
- WiFi: Broadcom BCM4360
- Bluetooth: Broadcom BCM20702

## Partition Scheme (ext4)
Suggested layout (adjust device names as needed):
- EFI (vfat): 512MB, label `BOOT`
- Swap: 8GB, label `swap`
- Root (ext4): rest of disk, label `nixos`

## Steps

### 1) Boot NixOS Installer
- Create NixOS USB installer and boot holding Option/Alt.
- Connect to WiFi via `nmtui` (optional).

### 2) Identify Disk
```bash
lsblk
# Likely /dev/nvme0n1 for PCIe SSD or /dev/sda for SATA
DISK=/dev/nvme0n1  # change if needed
```

### 3) Partition Disk
```bash
sudo parted "$DISK" -- mklabel gpt

# EFI partition (512MB)
sudo parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB
sudo parted "$DISK" -- set 1 esp on

# Swap (8GB)
sudo parted "$DISK" -- mkpart swap linux-swap 512MiB 8.5GiB

# Root (ext4)
sudo parted "$DISK" -- mkpart root ext4 8.5GiB 100%
```

### 4) Format Partitions
```bash
# NVMe uses p1/p2/p3; SATA uses 1/2/3
sudo mkfs.vfat -n BOOT "${DISK}p1"
sudo mkswap -L swap "${DISK}p2"
sudo mkfs.ext4 -L nixos "${DISK}p3"
```

### 5) Mount Filesystems
```bash
sudo swapon /dev/disk/by-label/swap
sudo mount /dev/disk/by-label/nixos /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/disk/by-label/BOOT /mnt/boot
```

### 6) Fetch Configuration
```bash
cd /mnt
sudo git clone https://github.com/feltnerm/nix-config
cd nix-config
```

### 7) Install NixOS
```bash
sudo nixos-install --flake .#markbook
# Set root password when prompted
```

### 8) Reboot
```bash
sudo reboot
```

## Post-Install Checks
- WiFi via NetworkManager (`nmtui`) / tray applet
- Bluetooth via Blueman (`blueman-manager`)
- Touchpad: natural scroll, tap-to-click
- Backlight: `light -A 10` (up) / `light -U 10` (down)
- Camera: FaceTime HD (test with `cheese`)
- Audio: PipeWire (test media playback)
- Kanata + Keychron K2 layout active when plugged

## Fine-Tuning
- HiDPI scaling (Hyprland): set monitor scale in Home Manager
  ```nix
  # Example in configs/nixos/markbook/home/mark.nix
  wayland.windowManager.hyprland.settings = {
    # e.g., 2x scaling on Retina
    monitor = "eDP-1,preferred,auto,2";
  };
  ```
- Function keys behavior: make F1–F12 default (press Fn for media)
  ```nix
  # Add in configs/nixos/markbook/hardware.nix or default.nix
  boot.kernelParams = [ "hid_apple.fnmode=2" ];
  ```
- Backlight control: `programs.light.enable = true` is set; optionally add `brightnessctl` to packages.
- Power tuning: install `powertop` and run `sudo powertop --auto-tune`.

## Notes
- Filesystem labels (`BOOT`, `swap`, `nixos`) must match `hardware.nix`.
- If your disk appears as SATA (`/dev/sda`), drop the `p` in partition names.
- Uses nixos-hardware `apple-macbook-pro-11-1` to enable Broadcom WiFi, camera, and Mac-specific bits.
