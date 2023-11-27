# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  config,
  ...
}:
let
  hostName = config.networking.hostName;
  sources = import ./npins;
in
{
  environment.etc."nixpkgs".source = sources.nixpkgs;
  nixpkgs.overlays =
    let
      npinsOverlay = self: _super: {
        inherit (sources) nixpkgs;
      };
    in
      [ npinsOverlay ];
  nix.nixPath = [
    "nixpkgs=/home/bzm3r/nixos-conf/npins"
    "nixos-config=/home/bzm3r/nixos-conf/default.nix"
  ];

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
