#!/usr/bin/env bash
set -euxo pipefail

nixos-install --root /mnt --system

nixos-enter --command sudo passwd bzm3r
su bzm3r

cd /home/bzm3r
git clone https://github.com/bzm3r/system
/home/bzm3r/system/setup-scripts/mk-snaps init
/home/bzm3r/system/setup-scripts/mk-symlinks
