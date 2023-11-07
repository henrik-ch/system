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
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };

    # explicitly set which device is to be used for storing hibernation/sleep
    # info if not ram
    resumeDevice = "/dev/disk/by-label/SWAP";
  };

    fileSystems."/" = {
        device = "/dev/disk/by-label/FS";
        fsType = "btrfs";
        options = [ "subvol=@" ];
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-label/FS";
        fsType = "btrfs";
        options = [ "subvol=@boot" ];
    };

    fileSystems."/root" = {
        device = "/dev/disk/by-label/FS";
        fsType = "btrfs";
        options = [ "subvol=@root" ];
    };

    fileSystems."/nix" = {
        device = "/dev/disk/by-label/FS";
        fsType = "btrfs";
        options = [ "subvol=@nix" ];
    };

    fileSystems."/home" = {
        device = "/dev/disk/by-label/FS";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
    };

    fileSystems."/efi" = {
        device = "/dev/disk/by-label/EFI";
        fsType = "vfat";
    };

    swapDevices =
    [
        { device = "/dev/disk/by-label/SWAP"; }
    ];


    services.logind = {
      lidSwitch = "hibernate";
      powerKey = "hibernate";
      powerKeyLongPress = "poweroff";
    };
    
    # fileSystems =
    #     (pkgs.lib.genAttrs
    #         (
    #             # fileSystems is a list of attribute sets of the form:
    #             # { mountPath, device, fsType, options, depends }
    #             #(see: https://github.com/NixOS/nixpkgs/blob/0cbe9f69c234a7700596e943bfae7ef27a31b735/nixos/modules/tasks/filesystems.nix#L33)
    #             # (we are fine with using the default value of depends)
    #             path:
    #                 let
    #                     diskLabel = "SYSTEM";
    #                     fsType = "btrfs";
    #                     defaultOptions = [ "compress=zstd:9" "thread_pool=4" ];
    #                 in
    #             # notation demarcating an attribute set
    #             {
    #                 device = "/dev/disk/by-label/${diskLabel}";
    #                 mountPath = "/${path}";
    #                 fsType = fsType;
    #                 options = [ "subvol=@${path}" ] ++ defaultOptions ;
    #             }
    #         )
    #         ["" "nix" "root" "home"]
    #     )
    #     ++
    #     [
    #         {
    #             mountPath = "/boot";
    #             device = "/dev/disk/by-label/BOOT";
    #             fsType = "vfat";
    #         }
    #     ];

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
}
