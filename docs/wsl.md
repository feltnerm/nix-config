# WSL (NixOS‑WSL)

Generic instructions for building, importing, and maintaining NixOS under Windows Subsystem for Linux.

## Overview
- Target output: NixOS‑WSL tarball via flake build
- Import into WSL using `wsl --import`
- Rebuild inside WSL with `nixos-rebuild` pointing to your flake

## Build Tarball
```bash
# Example for a WSL host named 'reddevil'
nix build .#nixosConfigurations.reddevil.config.system.build.tarball
```
Result appears at `result/tarball/nixos-wsl-<arch>.tar.gz`.

## Import into WSL (PowerShell)
Run PowerShell as Administrator:
```powershell
wsl --import <DistroName> C:\WSL\<DistroName> .\result\tarball\nixos-wsl-<arch>.tar.gz
wsl -d <DistroName>
```
Notes:
- `C:\WSL\<DistroName>` is a common storage path; adjust as needed.
- Replace `<DistroName>` with a name like `reddevil`.

## Rebuild Inside WSL
Point `nixos-rebuild` at your flake:
```bash
# Using Windows path
sudo nixos-rebuild switch --flake /mnt/c/Users/<user>/code/feltnerm/nix-config#<host>

# Or clone inside WSL for performance
cd ~/code
git clone /mnt/c/Users/<user>/code/feltnerm/nix-config
sudo nixos-rebuild switch --flake ~/code/nix-config#<host>
```

## Windows Integration Tips
- Access Windows C: drive: `cd /mnt/c`
- Jump to Windows home (custom helper): `winhome`
- Open Explorer in current dir (custom helper): `explorer`

## Notes
- Windows PATH is not included by default to avoid conflicts.
- Docker Desktop integration is not enabled by default; add native Docker if desired.
- See `docs/hosts.md` for general host lifecycle guidance and `docs/homes.md` for Home Manager usage.
