# based on the auto-generated hardware-configuration.nix
{ config, lib, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options = {
    machineLabel = lib.options.mkOption {
      type = lib.types.nullOr (lib.types.enum config.machineVariants);
      example = "d";
      default = null;
      description = lib.mdDoc "Host machine selection.";
    };
  };

  config = let
    machineSpecificSettings = {
      d = {
        availableKernelModules =
          [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
        kernelModules = [ "kvm-intel" ];
        homeFs = "3T";
        lidSwitch = { };
        cpuFreqGovernor = "performance";
        firmwareFamily = "intel";
      };
      l = {
        availableKernelModules =
          [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
        kernelModules = [ "kvm-amd" ];
        homeFs = "FS";
        lidSwitch = { lidSwitch = "hibernate"; };
        cpuFreqGovernor = "ondemand";
        firmwareFamily = "amd";
      };
    };
    thisMachineSettings = if (builtins.isNull config.machineLabel) then
      builtins.throw "config.machineLabel is NULL!"
    else
      machineSpecificSettings."${config.machineLabel}";
    getSettings = attrs: lib.attrsets.getAttrs attrs thisMachineSettings;
    getValue = attr: thisMachineSettings."${attr}";
  in ({
    boot = {
      initrd = {
        systemd.enable = true;
      } // getSettings [ "availableKernelModules" "kernelModules" ];

      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/efi";
        };
      };

      # explicitly set which device is to be used for storing hibernation/sleep
      # info if not ram
      resumeDevice = "/dev/disk/by-label/SWAP";
    };

    fileSystems = let
      btrfsMntPoint = diskLabel: subVolLabel:
        { extraOptions ? [ "compress=zstd" ] }: {
          device = "/dev/disk/by-label/${diskLabel}";
          fsType = "btrfs";
          options = [ "subvol=@${subVolLabel}" ] ++ extraOptions;
        };
    in {
      "/" = btrfsMntPoint "FS" "" { };
      "/boot" = btrfsMntPoint "FS" "boot" { extraOptions = [ ]; };
      "/root" = btrfsMntPoint "FS" "root" { };
      "/nix" = btrfsMntPoint "FS" "nix" { };
      "/home" = btrfsMntPoint (getValue "homeFS") "home" { };
      "/efi" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
      };
    };

    swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

    services.logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    } // (getSettings [ "lidSwitch" ]);

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

    networking.hostName = config.machineLabel; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networking.networkmanager.enable =
      true; # Easiest to use and most distros use this by default.

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor =
      lib.mkDefault (getValue "cpuFreqGovernor");
    hardware.cpu."${getValue "firmwareFamily"}".updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  });
}
