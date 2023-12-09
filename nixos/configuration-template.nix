{ pkgs
, ...
}:
{
  imports = [
    ./aliases.nix
    ./audio.nix
    ./basics.nix
    ./default-dirs.nix
    ./dev.nix
    ./git.nix
    # MISSING is the "template string" which will
    # be replaced with this host's name
    ./host-MISSING.nix
    ./lua.nix
    ./nix.nix
    ./productivity.nix
    ./security.nix
    ./starship
    ./vm.nix
    ./zip.nix
    ./zsh.nix
  ] ++
  [
    ./gui
  ];

  # options = {
  #   custom.mkHome = lib.options.mkOption {
  #     type = lib.types.anything;
  #     example = "x: /home/\${x}";
  #     description = lib.mdDoc
  #       "Function that takes a `userName` argument to produce the path of that user's home directory";
  #   };
  #   custom.userName = lib.options.mkOption {
  #     type = lib.types.str;
  #     example = "alice";
  #     description = lib.mdDoc "Username of the primary user for this machine, as a string.";
  #   };
  # };

  config =
  {
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
        extraGroups = [ "wheel" "networkmanager" "video" "rcontent_block" "libvirtd" ];
        useDefaultShell = true;
      };
    };
  };
}