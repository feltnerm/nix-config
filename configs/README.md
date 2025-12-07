# Systems Guide

This repo contains multiple NixOS hosts and shared Home Manager configs.

## Generic Guides
- NixOS: `configs/nixos/README.md`
- macOS (nix-darwin): `configs/darwin/README.md`
- Home Manager (standalone): `configs/home/README.md`

## Hosts
- codemonkey (Desktop Workstation): `configs/nixos/codemonkey/README.md`
- markbook (MacBook Pro 13" Late 2013): `configs/nixos/markbook/README.md`
- virtmark (Headless VM): `configs/nixos/virtmark/README.md`
- virtmark-gui (VM with GUI): `configs/nixos/virtmark-gui/README.md`

## Notes
- Filesystem labels in hardware files must match actual disk labels.
- For Retina/HiDPI, configure scaling in Hyprland via Home Manager.
- Apple keyboards: `boot.kernelParams = [ "hid_apple.fnmode=2" ];` to default F1–F12.
- Optional power tuning: `powertop --auto-tune`.
