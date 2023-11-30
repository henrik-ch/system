# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ ...
}:
{
  imports = [
    ./aliases.nix
    ./base.nix
    #./drvs/btrfs-rec.nix
    ./default-dirs.nix
    ./gui.nix
    ./host-MISSING.nix
    ./packages.nix
    ./starship.nix
  ];
}
