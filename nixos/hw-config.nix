# based on the auto-generated hardware-configuration.nix
{ config, lib, modulesPath, ... }:
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
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  config = {
    fileSystems = let
      pathSpecific = {
        "/home" = { dev = config.machine.homeDevice; };
        "/boot" = { enableCompression = false; };
        "/efi" = {
          dev = "EFI";
          fsType = "vfat";
        };
      };
      mkMountPoint = fsPath:
        _mkMountPoint fsPath (pathSpecific.${fsPath} or { });
    in lib.genAttrs [ "/" "/boot" "/root" "/nix" "/home" "/efi" ] mkMountPoint;

    swapDevices = [{ device = "/dev/disk/by-label/SWAP"; }];

    services.logind = {
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
      inherit (config.machine) lidSwitch;
    };

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    networking.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

    networking.hostName = config.machine.label; # Define your hostname.
    # Pick only one of the below networking options.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.sudo dmidecode -t 2
    networking.networkmanager.enable =
      lib.mkDefault true; # Easiest to use and most distros use this by default.

    nixpkgs.hostPlatform = "x86_64-linux";
    powerManagement = { inherit (config.machine) cpuFreqGovernor; };
    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}
