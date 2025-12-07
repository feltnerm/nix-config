# reddevil

NixOS-WSL development environment.

## Features

- CLI-only development environment
- Windows filesystem access at `/mnt/c`
- Full `mark` home-manager configuration
- catppuccin-macchiato theme

## Build the WSL tarball

```bash
nix build .#nixosConfigurations.reddevil.config.system.build.tarball
```

The resulting tarball will be located at:

```
result/tarball/nixos-wsl-x86_64-linux.tar.gz
```

## Install in WSL (PowerShell)

Run the following from PowerShell (as Administrator):

```powershell
wsl --import reddevil C:\WSL\reddevil .\result\tarball\nixos-wsl-x86_64-linux.tar.gz
wsl -d reddevil
```

This uses the default storage location `C:\WSL\reddevil`.

## Rebuild inside WSL

After importing, you can rebuild directly inside WSL:

```bash
sudo nixos-rebuild switch --flake /mnt/c/Users/mark/code/feltnerm/nix-config#reddevil
```

Or clone your config into WSL for faster rebuilds:

```bash
cd ~/code
git clone /mnt/c/Users/mark/code/feltnerm/nix-config
sudo nixos-rebuild switch --flake ~/code/nix-config#reddevil
```

## Windows Integration Tips

- Access Windows C: drive: `cd /mnt/c`
- Jump to Windows home: `winhome`
- Open Windows Explorer in current dir: `explorer`

## Notes

- Windows PATH is not included to avoid conflicts.
- Docker Desktop integration is not enabled; you can add native Docker later if needed.
