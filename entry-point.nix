{ lib, ... }: {
  imports = [ ./root.nix ];

  options = {
    machineLabel = lib.options.mkOption {
      type = lib.types.enum [ "d" "l" ];
      example = "d";
      description = lib.mdDoc "Host machine selection.";
    };
  };

  config = { machineLabel = "d"; };
}
