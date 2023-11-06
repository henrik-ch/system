#!/usr/bin/env zsh

snap_path=$2

# http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html#index-read
if read -q "create copy of home? (Yy)"; then
    /home/bzm3r/nixos-conf/mk-snapshot
fi

sudo btrfs subvolume delete /home
sudo btrfs subvolume snapshot $snap_path /home
