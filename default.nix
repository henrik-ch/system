# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  ...
}:
let
  hostName = config.networking.hostName;
in
{
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
  imports = [
    (
      if hostName == "d"
        then ./host-d.nix
      else
        (
          if hostName == "l" then
            ./host-l.nix
          else
            abort "${hostName} has no associated configuration!"
        )
    )
    ./core
    ./gui-common.nix
    ./gui-sway.nix
  ];
}