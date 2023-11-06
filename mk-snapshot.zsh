#!/usr/bin/env zsh

sudo btrfs subvolume snapshot /home /snaps/home_$(date +"%y-%m-%d_%H-%M-%S")
