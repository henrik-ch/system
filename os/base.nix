{ pkgs, ... }:

{
  imports = [
    ./base-audio.nix
    ./base-programs.nix
    ./base-time.nix
  ];
  
  boot = {
    initrd.systemd.enable = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # explicitly set which device is to be used for storing hibernation/sleep
    # info if not ram
    resumeDevice = "/dev/disk/by-label/SWAP";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  i18n.defaultLocale = "en_US.UTF-8";

  # a bigger, default tty font
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-122n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  security = {
    sudo.extraConfig =
    '' Defaults lecture = never '';
    polkit.enable = true;
  };

  services = {
    # hardware scanner + firmware recommender
    fwupd.enable = true;
    udisks2.enable = true;
  };

  system.stateVersion = "23.05"; # Did you read the comment?
}
