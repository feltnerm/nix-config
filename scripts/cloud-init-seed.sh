#!/usr/bin/env bash
set -euo pipefail

# Create a cloud-init seed ISO for injecting SSH keys and user config.
# Usage:
#   scripts/cloud-init-seed.sh <username> <ssh_pubkey_file> [output_iso]
# Example:
#   scripts/cloud-init-seed.sh mark ~/.ssh/id_ed25519.pub seed.iso

if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Usage: $0 <username> <ssh_pubkey_file> [output_iso]" >&2
  exit 1
fi

USERNAME="$1"
PUBKEY_FILE="$2"
OUTPUT_ISO="${3:-seed.iso}"

if [[ ! -f $PUBKEY_FILE ]]; then
  echo "SSH public key file not found: $PUBKEY_FILE" >&2
  exit 1
fi

PUBKEY=$(cat "$PUBKEY_FILE")

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

cat >"$WORKDIR/user-data" <<EOF
#cloud-config
users:
  - name: $USERNAME
    ssh_authorized_keys:
      - $PUBKEY
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /run/current-system/sw/bin/zsh
ssh_pwauth: false
chpasswd:
  list: |
    $USERNAME:*
  expire: false
EOF

touch "$WORKDIR/meta-data"

if ! command -v cloud-localds >/dev/null 2>&1; then
  echo "cloud-localds not found. Install cloud-utils-growpart or cloud-image-utils." >&2
  exit 1
fi

cloud-localds "$OUTPUT_ISO" "$WORKDIR/user-data" "$WORKDIR/meta-data"

echo "Seed ISO created: $OUTPUT_ISO"
