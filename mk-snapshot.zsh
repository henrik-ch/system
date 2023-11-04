#!/usr/bin/env zsh

snap_path = /@home_$(date +"%y_%m_%d-%H_%M_%S)
btrfs subvolume snapshot /@home $snap_path
