# based on the auto-generated hardware-configuration.nix

let
  machineSpecificSettings = {
    d = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ "kvm-intel" ];
      homeDevice = "3T";
      lidSwitch = "ignore";
      cpuFreqGovernor = "performance";
    };
    l = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "kvm-amd" ];
      homeDevice = "FS";
      lidSwitch = "hibernate";
      cpuFreqGovernor = "ondemand";
    };
  };
in { config, lib, modulesPath, ... }:
let
  devPath = label: "/dev/disk/by-label/${label}";
  _mkMountPoint = fsPath:
    { dev ? "FS", fsType ? "btrfs", enableCompression ? true }:
    {
      device = devPath dev;
      inherit fsType;
    } // lib.optionalAttrs (fsType == "btrfs") {
      options = [ "subvol=${builtins.replaceStrings [ "/" ] [ "@" ] fsPath}" ]
        ++ lib.optional enableCompression "compress=zstd";
    };
  machineSettings = machineSpecificSettings.${config.machineLabel};
  machineInitrd =
    lib.attrsets.getAttrs [ "availableKernelModules" "kernelModules" ]
    machineSettings;
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options = {
    testOption = lib.mkOption {
      type = lib.types.str;
      default = "undefined";
    };
  };

  config = {
    testOption = devPath machineSettings.homeDevice;

    boot = {
      initrd = { systemd.enable = true; } // machineInitrd;

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
      pathSpecific = {
        "/home" = { dev = machineSettings.homeDevice; };
        "/boot" = { enableCompression = false; };
        "/efi" = { fsType = "vfat"; };
      };
      mkMountPoint = fsPath:
        _mkMountPoint fsPath (pathSpecific.${fsPath} or { });
    in lib.genAttrs [ "/" "/boot" "/root" "/nix" "/home" "/efi" ] mkMountPoint;

    swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

    services.logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
      inherit (machineSettings) lidSwitch;
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

    networking.hostName = config.machineLabel; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.sudo dmidecode -t 2
    networking.networkmanager.enable =
      lib.mkDefault true; # Easiest to use and most distros use this by default.

    nixpkgs.hostPlatform = "x86_64-linux";
    powerManagement = { inherit (machineSettings) cpuFreqGovernor; };
    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}
