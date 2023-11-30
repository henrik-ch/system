inputs@{ lib
, pkgs
, config
, ...
}: {
  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;


  nix.settings = {
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
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
