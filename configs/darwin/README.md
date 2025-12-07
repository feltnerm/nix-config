# macOS (nix-darwin)

This guide covers applying nix-darwin and Home Manager configs on macOS hosts. Host-specific notes should live in `configs/darwin/<host>`.

## Prereqs
- Install Nix on macOS (multi-user recommended)
- Ensure Xcode Command Line Tools are installed (`xcode-select --install`)

## Apply configs via flake
```bash
# from the repo root
nix build .#darwinConfigurations.<host>.system
/Applications/Nix/nix-daemon --version # verify Nix is working
# activate configuration
./result/sw/bin/darwin-rebuild switch --flake .#<host>
```

Alternatively, use `nix run`:
```bash
nix run nix-darwin -- switch --flake .#<host>
```

## Home Manager on macOS
- Home Manager is integrated via the flake modules.
- Use `darwin-rebuild switch --flake` as above, or `home-manager switch --flake .#<user>@<host>` depending on your setup.

## Notes
- Some services require granting permissions in System Settings after activation.
- Reboot may be necessary after first `darwin-rebuild`.
