{ lib, pkgs, ... }:
{
  imports = [
    # Import your main configuration
    ./nixos/configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    # We're using niv to manage the systems Nixpkgs version, install it globally for ease
    npins
  ];

  # Use the Nixpkgs config and overlays from the local files for this NixOS build
  nixpkgs = {
    config = import ./nixos/nixpkgs/config.nix;
    overlays = import ./nixos/nixpkgs/overlays.nix;
  };

  # Makes commands default to the same Nixpkgs, config, overlays and NixOS configuration
  nix.nixPath = [
    "nixpkgs=${pkgs.path}"
    "nixos-config=${toString ./root.nix}"
    "nixpkgs-overlays=${toString ./nixos/nixpkgs/overlays.nix}"
  ];
  environment.variables.NIXPKGS_CONFIG = lib.mkForce (toString ./nixos/nixpkgs/config.nix);

  # Remove the stateful nix-channel command
  environment.extraSetup = ''
    rm --force $out/bin/nix-channel
  '';

  # This option is broken when set false, prevent people from setting it to false
  # And we implement the important bit above ourselves
  nix.channel.enable = true;
}
