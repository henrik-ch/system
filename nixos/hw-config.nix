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
      cpuFamily = "intel";
    };
    l = {
      availableKernelModules =
        [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "kvm-amd" ];
      homeDevice = "FS";
      lidSwitch = "hibernate";
      cpuFreqGovernor = "ondemand";
      cpuFamily = "amd";
    };
  };
  devByLabel = label: "/dev/disk/by-label/${label}";
  listOption = option: enable: if enable then [ option ] else [ ];
  mkMountPoint =
    { devLabel ? "FS", fsPath, fsType ? "btrfs", enableCompression ? true }: {
      "/${fsPath}" = {
        device = devByLabel devLabel;
        fsType = "btrfs";
        options = if fsType == "btrfs" then
          [ "subvol=@${fsPath}" ]
          ++ (listOption "compress=zstd" enableCompression)
        else
          [ ];
      };
    };
in { config, lib, modulesPath, ... }:
let
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
    testOption = devByLabel machineSettings.homeDevice;

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

    fileSystems = lib.attrsets.mergeAttrsList ((map mkMountPoint [
      {
        devLabel = "FS";
        fsPath = "";
      }
      {
        devLabel = "FS";
        fsPath = "boot";
        enableCompression = false;
      }
      {
        devLabel = "FS";
        fsPath = "root";
      }
      {
        devLabel = "FS";
        fsPath = "nix";
      }
      {
        devLabel = machineSettings.homeDevice;
        fsPath = "home";
      }
      {
        devLabel = "EFI";
        fsPath = "efi";
        fsType = "vfat";
      }
    ]));

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
