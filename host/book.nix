# based on the auto-generated hardware-configuration.nix
{ pkgs, config, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      systemd.enable = true;
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" "sdhci_pci" ];
      kernelModules = [ "kvm-amd" ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # explicitly set which device is to be used for storing hibernation/sleep
    # info if not ram
    resumeDevice = "/dev/disk/by-label/SWAP";
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd:9" "thread_pool=4"];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd:9" "thread_pool=4"];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/SYSTEM";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd:9" "thread_pool=4"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-label/SWAP"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  networking.hostName = "book"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    tlp
    thermald
    acpilight
  ];
}
