{ pkgs, config, ... }: {
  imports = [
    ./admin.nix
    ./aliases.nix
    ./audio.nix
    ./basics.nix
    ./boot.nix
    ./xdg.nix
    ./dev.nix
    ./git.nix
    ./lua.nix
    ./nix.nix
    ./productivity.nix
    ./security.nix
    ./vm.nix
    ./xdg.nix
    ./zip.nix
    ./zsh.nix
  ] ++ [ ./gui ./starship ];

  config = {
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
      font = "${terminus_font}/share/consolefonts/ter-132n.psf.gz";
      packages = [ terminus_font ];
      keyMap = "us";
    };

    security = {
      sudo.extraConfig = "Defaults lecture = never ";
      polkit.enable = true;
    };

    services = {
      # hardware scanner + firmware recommender
      fwupd.enable = true;
      udisks2.enable = true;
      # kmscon = {
      #   enable = true;
      #   fonts = [
      #     {
      #       name = "Inconsolata";
      #       package = pkgs.inconsolata-nerdfont;
      #     }
      #     {
      #       name = "Source Code Pro";
      #       package =
      #         (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; });
      #     }
      #   ];
      #   extraConfig = ''
      #   font-size=16
      #   font-dpi=121
      #   '';
      #   hwRender = true;
      #   autologinUser = config.singleUser;
      # };
    };

    # should set up one-time auto-detect (perhaps on startup/login)
    time.timeZone = "America/Vancouver";

    system.stateVersion =
      "24.05"; # TODO: properly understand why this should not be changed in general.

    users = {
      defaultUserShell = "${pkgs.zsh}/bin/zsh";
      users."${config.singleUser}" = {
        isNormalUser = true;
        home = config.userHome;
        extraGroups =
          [ "wheel" "networkmanager" "video" "rcontent_block" "libvirtd" ];
        useDefaultShell = true;
      };
    };

    cargoHomeBase = config.userHome;
  };
}
