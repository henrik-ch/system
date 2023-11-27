# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  ...
}:
{
 imports = [
    ./host-MISSING.nix
    ./core
    ./gui-common.nix
    ./gui-sway.nix
  ];
}
