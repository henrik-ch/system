# based on the auto-generated hardware-configuration.nix
{ config, lib, modulesPath, ... }:
let
  machineVariants = [ "d" "l" ];
  mkIfMachine = x: item: lib.mkIf (config.machineLabel == x) item;
  mkMergeMachine = perMachineItems:
    lib.mkMerge
    (map (x: (mkIfMachine x perMachineItems."${x}")) machineVariants);
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  options = {
    machineLabel = lib.options.mkOption {
      type = lib.types.nullOr lib.types.enum machineVariants;
      example = "d";
      default = null;
      description =
        lib.mdDoc "Username of the primary user for this machine, as a string.";
    };
  };

  config = lib.throwIf (builtins.isNull config.machineLabel)
    ("No machineLabel provided! Make sure to run nixos-rebuild etc. with an appropriate specialisation (one of 'd' or 'l'") ({
      boot = {
        initrd = {
          systemd.enable = true;
          availableKernelModules = mkMergeMachine {
            d = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
            l = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
          };
          kernelModules = mkMergeMachine {
            d = [ "kvm-intel" ];
            l = [ "kvm-amd" ];
          };
        };

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
        "/home" = btrfsMntPoint (mkMergeMachine {
          d = "3T";
          l = "FS";
        }) "home" { };
        "/efi" = {
          device = "/dev/disk/by-label/EFI";
          fsType = "vfat";
        };
      };

      swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

      services.logind = {
        powerKey = "hibernate";
        powerKeyLongPress = "poweroff";
      } // (mkMergeMachine {
        d = { };
        l = { lidSwitch = "hibernate"; };
      });

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
      powerManagement.cpuFreqGovernor = lib.mkDefault (mkMergeMachine {
        d = "performance";
        l = "ondemand";
      });
      hardware.cpu = let
        updateSetting =
          lib.mkDefault config.hardware.enableRedistributableFirmware;
      in mkMergeMachine {
        d = { intel.updateMicrocode = updateSetting; };
        l = { amd.updateMicrocode = updateSetting; };
      };
    });
}
