{ config, ... }: {
  boot = {
    initrd = { systemd.enable = true; } // config.machine.initrd;

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
}
