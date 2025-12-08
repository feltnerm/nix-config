# Secrets Directory

This directory contains encrypted secrets managed by agenix (ragenix).

- DO NOT commit unencrypted secrets
- Only `.age` files are encrypted and safe to commit
- See `docs/secrets.md` for full documentation

## Quick Reference

Edit a secret:
  agenix -e secrets/path/to/secret.age

Add new secret:
  1. Create/edit: agenix -e secrets/path/to/newsecret.age
  2. Add to secrets.nix with appropriate publicKeys
  3. Commit the .age file

Convert SSH key to age:
  ssh-to-age < ~/.ssh/id_ed25519.pub
  ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub  # for host keys
