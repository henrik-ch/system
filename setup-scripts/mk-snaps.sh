#!/usr/bin/env zsh

directory=$1

# make parent directories if they do not exist
sudo mkdir -p /snaps/$1/
# verbose, commit after operation is done
# https://unix.stackexchange.com/a/603198/95597 suggests that btrfs subvolume delete supports globbing
sudo btrfs subvolume delete -v -c /snaps/$1/*
# read only snapshot
sudo btrfs subvolume snapshot -r /home /snaps/$1/home
sudo btrfs subvolume snapshot -r /root /snaps/$1/root
sudo btrfs subvolume snapshot -r /boot /snaps/$1/boot
sudo btrfs subvolume snapshot -r /boot /snaps/$1/nix

