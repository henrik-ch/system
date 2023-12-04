#!/usr/bin/env bash
set -euo pipefail

host=$(hostname)
echo "Copying iso to ${1}..."
sudo cp ./result-${host}/iso/*.iso ${1}
echo "Syncing..."
sync
echo "Finished copying to USB at ${1}!"
