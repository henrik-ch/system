#!/usr/bin/env bash
set -euxo pipefail

host=$(hostname)
sudo cp ./result-${host}/iso/*.iso ${1}
sync
