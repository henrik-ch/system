inputs@{ lib
, pkgs
, config
, ...
}: {
  imports = [
    ./aliases.nix
    ./audio.nix
    ./basics.nix
    ./default-dirs.nix
    ./editing.nix
    ./git.nix
    # MISSING is the "template string" which will
    # be replaced with this host's name
    ./host-MISSING.nix
    ./lua.nix
    ./nix.nix
    ./productivity.nix
    ./security.nix
    ./starship.nix
    ./vm.nix
    ./zip.nix
    ./zsh.nix
  ] ++
  [
    ./gui
  ];
  nix.settings = {
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # enable some of the experimental commands for now
    experimental-features = [ "nix-command" ];

  };

  hardware.opengl.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  # a bigger, default tty font
  console = with pkgs; {
    earlySetup = true;
    font = "${terminus_font}/share/consolefonts/ter-122n.psf.gz";
    packages = [ terminus_font ];
    keyMap = "us";
  };

  security = {
    sudo.extraConfig = ''Defaults lecture = never '';
    polkit.enable = true;
  };

  services = {
    # hardware scanner + firmware recommender
    fwupd.enable = true;
    udisks2.enable = true;
  };

  # should set up one-time auto-detect (perhaps on startup/login)
  time.timeZone = "America/Vancouver";

  system.stateVersion = "24.05"; # Apparently, no need to change, in order to make it robust to syntax issues...

  users = {
    defaultUserShell = "${pkgs.zsh}/bin/zsh";
    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extraGroups = [ "wheel" "networkmanager" "video" "rcontent_block" "libvirtd" ];
      useDefaultShell = true;
    };
  };
}
