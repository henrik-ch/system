{ lib, pkgs, ... }: {
  imports = [
    # Import your main configuration
    ./nixos/configuration.nix
  ];

  config = let
    genSpecialization = machineLabel: {
      inheritParentConfig = true;
      configuration = { config = { inherit machineLabel; }; };
    };
  in {
    specialisation = lib.attrsets.genAttrs [ "d" "l" ] genSpecialization;

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

    sources = (import ./npins);
    singleUser = "bzm3r";

    # This option is broken when set false, prevent people from setting it to false
    # And we implement the important bit above ourselves
    nix.channel.enable = true;
  };
}
