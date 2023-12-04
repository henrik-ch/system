#!/usr/bin/env bash
set -euo pipefail

nixos-install --root /mnt --system

nixos-enter --command sudo passwd bzm3r ; echo "Password set. Login:" ; su bzm3r

cd /home/bzm3r ; git clone https://github.com/bzm3r/nixos-conf ; /home/bzm3r/nixos-conf/setup-scripts/mk-snaps init ; /home/bzm3r/nixos-conf/setup-scripts/mk-symlinks

echo "Installation complete!"
