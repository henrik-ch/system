#!/bin/sh
host=$(hostname)
rm -rf result-${host}
if  [$? -eq 0 ]; then
    echo "Successfully removed existing result-${host}"
else
    echo "Could note delete result-${host}"
fi

nix-shell -p nixos-generators --run "nixos-generate --format iso --configuration ./minimal.nix -o result-${host}"
if  [$? -eq 0 ]; then
    echo "Finished creating iso at result-${host}"
else
    echo "Error creating iso at result-${host}"
fi
