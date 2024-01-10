{ lib, pkgs, config, ... }: let
  machineSettings = {
        d = {
          initrd = {
            availableKernelModules =
              [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "amdgpu" ];
            kernelModules = [ "kvm-intel" ];
          };
          homeDevice = "3T";
          lidSwitch = "ignore";
          cpuFreqGovernor = "performance";
        };
        l = {
          initrd = {
            availableKernelModules =
              [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" "amdgpu" ];
            kernelModules = [ "kvm-amd" ];
          };
          homeDevice = "FS";
          lidSwitch = "hibernate";
          cpuFreqGovernor = "ondemand";
        };
      };
  selectMachine = label: (builtins.getAttr label machineSettings) // {
    inherit label;
  };
in {
  imports = [ ./nixos/hw-config.nix ./nixos/configuration.nix ];

  options = {
    sources = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      example = "{ nixpkgs = { ... }; rust-shell = { ... }; }";
      description = lib.mdDoc "Derivation of a rust-shell package";
    };
    machineLabel = lib.options.mkOption {
      type = lib.types.enum [ "d" "l" ];
      example = "d";
      description = lib.mdDoc "Host machine selection.";
    };
    machine = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      example = "";
      description = lib.mdDoc "Machine settings.";
    };
  };

  config = {
    sources = lib.mkForce (import ./npins);
    machine = lib.mkForce (selectMachine config.machineLabel);

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

    environment.variables = {
      NIXPKGS_CONFIG = lib.mkForce (toString ./nixpkgs/config.nix);
      NIX_PATH = lib.mkForce (builtins.getEnv "NIX_PATH");
      NIXOS_CONFIG_ENTRY = lib.mkForce (builtins.getEnv "NIXOS_CONFIG_ENTRY");
      NIXOS_CONFIG_DIR = lib.mkForce (builtins.getEnv "NIXOS_CONFIG_DIR");
    };

    # Remove the stateful nix-channel command
    environment.extraSetup = ''
      rm --force $out/bin/nix-channel
    '';

    # This option is broken when set false, prevent people from setting it to false
    # And we implement the important bit above ourselves
    nix.channel.enable = true;
  };
}
