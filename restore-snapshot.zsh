#!/usr/bin/env zsh

snap_path=$2

# http://zsh.sourceforge.net/Doc/Release/Shell-Builtin-Commands.html#index-read
if read -q "create copy of home? (Yy)"; then
    $HOME/nixos-conf/mk-snapshot
fi

btrfs subvolume delete @home
btrfs subvolume snapshot $snap_path @home
