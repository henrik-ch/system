{ lib, pkgs, ... }: {
  imports = [ ./nixos/hw-config.nix ./nixos/configuration.nix ];

  options = {
    sources = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      example = "{ nixpkgs = { ... }; rust-shell = { ... }; }";
      description = lib.mdDoc "Derivation of a rust-shell package";
    };
    singleUser = lib.options.mkOption {
      type = lib.types.str;
      example = "alice";
      description =
        lib.mdDoc "Username of the primary user for this machine, as a string.";
    };
    homeBase = lib.options.mkOption {
      type = lib.types.str;
      example = "/home";
      default = "/home";
      description = lib.mdDoc "Base directory where home values are placed.";
    };
  };

  config = {
    singleUser = "bzm3r";
    sources = import ./npins;
    homeBase = "/home";

    environment.systemPackages = with pkgs;
      [
        # We're using niv to manage the systems Nixpkgs version, install it globally for ease
        npins
      ];

    # Use the Nixpkgs config and overlays from the local files for this NixOS build
    nixpkgs = {
      config = import ./nixpkgs/config.nix;
      overlays = import ./nixpkgs/overlays.nix;
    };

    # Makes commands default to the same Nixpkgs, config, overlays and NixOS configuration
    nix.nixPath = [
      "nixpkgs=${pkgs.path}"
      "nixos-config=${toString ./root.nix}"
      "nixpkgs-overlays=${toString ./nixpkgs/overlays.nix}"
    ];
    environment.variables.NIXPKGS_CONFIG =
      lib.mkForce (toString ./nixpkgs/config.nix);

    # Remove the stateful nix-channel command
    environment.extraSetup = ''
      rm --force $out/bin/nix-channel
    '';

    # This option is broken when set false, prevent people from setting it to false
    # And we implement the important bit above ourselves
    nix.channel.enable = true;
  };
}
