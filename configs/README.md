# Systems Install Guide

This repo contains multiple NixOS hosts and shared home-manager configs. Use the guides below to install or build each system.

## Common Prereqs
- Boot a NixOS installer USB
- Connect to network (e.g., `nmtui`)
- Partition, format, and mount target disks
- Clone this repo under `/mnt`

## Partitioning Cheatsheet
- EFI (vfat): 512MB, label `BOOT`
- Swap: choose size (e.g., 4–8GB)
- Root: ext4 or zfs depending on host

---

## codemonkey (Desktop Workstation)
- Path: `configs/nixos/codemonkey`
- Filesystem: ZFS (via disko)
- GUI: Hyprland + greetd
- Keyboard: Kanata (Keychron K2)

### Install (ZFS + disko)
1. Boot installer and get disks by id
2. Ensure the NVMe ID matches `hardware.nix` (`/dev/disk/by-id/...`)
3. Run disko to create layout:
   ```bash
   nix run github:nix-community/disko -- --mode zap_create_mount configs/nixos/codemonkey/hardware.nix
   ```
4. Clone repo to `/mnt` and install:
   ```bash
   cd /mnt
   git clone https://github.com/feltnerm/nix-config
   cd nix-config
   nixos-install --flake .#codemonkey
   ```

---

## markbook (MacBook Pro 13" Late 2013)
- Path: `configs/nixos/markbook`
- Filesystem: ext4 (EFI + swap + root)
- GUI: Hyprland + greetd
- Laptop features: TLP, thermald, FaceTimeHD, libinput touchpad
- Bluetooth: Blueman
- Backlight: `light` and `brightnessctl`

### Install (ext4)
See full guide at `configs/nixos/markbook/README.md`.

Short version:
```bash
DISK=/dev/nvme0n1 # or /dev/sda
parted "$DISK" -- mklabel gpt
parted "$DISK" -- mkpart ESP fat32 1MiB 512MiB; parted "$DISK" -- set 1 esp on
parted "$DISK" -- mkpart swap linux-swap 512MiB 8.5GiB
parted "$DISK" -- mkpart root ext4 8.5GiB 100%
mkfs.vfat -n BOOT ${DISK}p1; mkswap -L swap ${DISK}p2; mkfs.ext4 -L nixos ${DISK}p3
mount /dev/disk/by-label/nixos /mnt; mkdir -p /mnt/boot; mount /dev/disk/by-label/BOOT /mnt/boot; swapon /dev/disk/by-label/swap
cd /mnt; git clone https://github.com/feltnerm/nix-config; cd nix-config
nixos-install --flake .#markbook
```

---

## virtmark (Headless VM)
- Path: `configs/nixos/virtmark`
- Filesystem: ext4 (labels `nixos`, `boot`, `swap`)
- Services: cloud-init, qemuGuest
- Networking: NetworkManager, firewall enabled

### Install (VM image or manual)
- For images via nixos-generators (example):
  ```bash
  nix build .#images.virtmark.qcow2
  ```
- Manual install (ext4): create partitions (as above), mount, then:
  ```bash
  nixos-install --flake .#virtmark
  ```

---

## virtmark-gui (VM with GUI)
- Path: `configs/nixos/virtmark-gui`
- Filesystem: ext4 (labels `nixos`, `boot`, `swap`)
- Services: cloud-init, qemuGuest
- GUI: Hyprland + greetd, Firefox

### Install (VM image or manual)
- For images via nixos-generators (example):
  ```bash
  nix build .#images.virtmark-gui.qcow2
  ```
- Manual install:
  ```bash
  nixos-install --flake .#virtmark-gui
  ```

---

## Home-Manager (standalone)
- Path: `configs/home/mark`
- Use via flake outputs or with `home-manager switch` depending on environment.

## Notes
- Labels in hardware files must match your actual partition labels.
- For Retina/HiDPI, configure scaling in Hyprland under home-manager.
- Function keys behavior (Apple keyboards): `boot.kernelParams = [ "hid_apple.fnmode=2" ];`.
- Power tuning: `powertop --auto-tune`.
