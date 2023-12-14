{ pkgs, lib, config, ... }:
let
  mapGenAttrs = inputs: inputToAttr: attrToVal:
    lib.genAttrs (map inputToAttr inputs) attrToVal;

  mkXdgDir = end: mid: "XDG_${mid}_${end}";

  xdgSubDirs = mapGenAttrs [
    "DESKTOP"
    "DOCUMENTS"
    "DOWNLOAD"
    "MUSIC"
    "PICTURES"
    "PUBLICSHARE"
    "TEMPLATES"
    "VIDEOS"
  ] (x: mkXdgDir x "DIR") (x: "$HOME");

  xdgHomeDirs = builtins.listToAttrs (map (x: {
    name = mkXdgDir x "HOME";
    value = "$HOME/${x}";
  }) [ "CACHE" "CONFIG" "DATA" "STATE"  ] );
in {
  environment.systemPackages = with pkgs; [ xdg-user-dirs ];

  environment.variables = xdgSubDirs // xdgHomeDirs;
}
