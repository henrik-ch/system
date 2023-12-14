{ config, lib, pkgs, _user, ... }:
let
  inherit (builtins) replaceStrings;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) flatten;
  inherit (lib.modules) mkIf mkDefault mkDerivedConfig;
  inherit (lib.options) mkOption;
  inherit (lib.types) attrsOf lines nullOr path str submodule;

  _tmpfileType = prefix:
    # https://nixos.org/manual/nixos/unstable/#section-option-types-submodule
    # https://nixos.org/manual/nixos/unstable/#sec-option-types-composed
    attrsOf (submodule ({ config, options, name, ... }: {
      options = {
        source = mkOption { type = path; };
        target = mkOption { type = str; };
        text = mkOption {
          default = null;
          type = nullOr lines;
        };
      };

      config = {
        source = mkIf (config.text != null) (mkDerivedConfig options.text
          (pkgs.writeText
            "xdg-${prefix}-${replaceStrings [ "/" ] [ "-" ] name}"));
        target = mkDefault name;
      };
    }));
in {
  options = {
    home.file = mkOption {
      default = { };
      type = _tmpfileType "homeFile";
    };

    xdg = {
      configFile = mkOption {
        default = { };
        type = _tmpfileType "configFile";
      };

      dataFile = mkOption {
        default = { };
        type = _tmpfileType "dataFile";
      };
    };
  };

  # uses temp files to enforce volatility of symlinks
  # https://search.nixos.org/options?channel=unstable&show=systemd.user.tmpfiles.users.%3Cname%3E.rules
  config.systemd.user.tmpfiles.users.${_user}.rules = let
    # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html
    _tmpStr = prefix: _: file:
      "L+ '${prefix}/${file.target}' - - - - ${file.source}";
    # see %h in the following table:
    # https://www.freedesktop.org/software/systemd/man/latest/tmpfiles.d.html#Specifiers
  in flatten [
    (mapAttrsToList (_tmpStr "%h") config.home.file)
    (mapAttrsToList (_tmpStr "%h/.config") config.xdg.configFile)
    (mapAttrsToList (_tmpStr "%h/.local/share") config.xdg.dataFile)
  ];
}
