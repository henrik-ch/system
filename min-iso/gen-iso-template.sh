#/usr/bin/env bash
set -euxo pipefail

host=$(hostname)
rm -rf result-${host}

nix-shell -p nixos-generators --run "nixos-generate --format iso --configuration ./minimal.nix -o result-${host}"
