{ pkgs, config, lib, ... }:
let
  mapGenAttrs = inputs: inputToAttr: attrToVal:
    lib.genAttrs (map inputToAttr inputs) attrToVal;

  mkXdgDir = end: mid: "XDG_${mid}_${end}";

  xdgHomeSecondaryDirs = mapGenAttrs [
    "DESKTOP"
    "DOCUMENTS"
    "DOWNLOAD"
    "MUSIC"
    "PICTURES"
    "PUBLICSHARE"
    "TEMPLATES"
    "VIDEOS"
  ] (mkXdgDir "DIR") (x: "$HOME");

  xdgHomePrimaryDirs = builtins.listToAttrs (map (x: {
    name = mkXdgDir "HOME" x;
    value = "$HOME/${x}";
  }) [ "CACHE" "CONFIG" "DATA" "STATE" ]);
in {
  options = {
    homeBase = lib.options.mkOption {
      type = lib.types.str;
      default = "/home";
      description = lib.mdDoc
        "Default base directory used for [normal user homes](https://github.com/NixOS/nixpkgs/blob/90c3374749364dc58f7077e4cfb53caa0bd29350/nixos/modules/config/users-groups.nix#L364).";
    };
    userName = lib.options.mkOption {
      type = lib.types.str;
      example = "alfred";
      description =
        lib.mdDoc "Username of the primary user for this machine, as a string.";
    };
    userHome = lib.options.mkOption {
      type = lib.types.str;
      example = "/home/alfred";
      default = "/home/${config.userName}";
      description =
        lib.mdDoc "Home directory of the primary user for this machine.";
    };
    userXdgDirs = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.string;
      description = lib.mdDoc "Custom XDG user dirs";
    };
  };
  config = {
    # should set up one-time auto-detect (perhaps on startup/login)
    time.timeZone = "America/Vancouver";
    i18n.defaultLocale = "en_US.UTF-8";

    userName = lib.mkForce "bzm3r";
    userXdgDirs = xdgHomeSecondaryDirs // xdgHomePrimaryDirs;

    users = {
      defaultUserShell = "${pkgs.zsh}/bin/zsh";
      users."${config.userName}" = {
        isNormalUser = true;
        home = config.userHome;
        extraGroups =
          [ "wheel" "networkmanager" "video" "rcontent_block" "libvirtd" ];
        useDefaultShell = true;
      };
    };

    cargoHomeBase = config.userHome;
    cabalHomeBase = config.userHome;
  };
}
