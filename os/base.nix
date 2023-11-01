{ pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      initrd.systemd.enable = true;
      efi.canTouchEfiVariables = true;
      resumeDevice = "/dev/disk/by-label/SWAP";
    };
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

  # hardware scanner + firmware recommender
  services.fwupd.enable = true;

  system.stateVersion = "23.05"; # Did you read the comment?
}