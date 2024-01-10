{ pkgs, lib, ... }:
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
    userXdgDirs = lib.options.mkOption {
      type = lib.types.attrsOf lib.types.string;
      description = lib.mdDoc "Custom XDG user dirs";
    };
  };
  config = {
    environment.systemPackages = with pkgs; [ xdg-user-dirs ];

    environment.variables =
      lib.traceVal (xdgHomeSecondaryDirs // xdgHomePrimaryDirs);

    xdg = {
      mime = {
        enable = true;
        defaultApplications = {
          "inode/directory" = "thunar.desktop";
          "image/gif" = [ "firefox.desktop" ];
        };
      };
    };
  };
}
