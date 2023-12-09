{ pkgs, lib, ... }:
let
  sources = import ../npins;
in
{
  options = {
    dev.cargoHomeBase = lib.options.mkOption {
      type = lib.types.path;
      example = "/home/alice";
      description = lib.mdDoc
        "Directory where $CARGO_HOME and $SCCACHE_DIR will be placed for a Rust shell";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      helix # no vim or emacs allowed
      shellcheck
      elfutils
      (
        callPackage sources.rust-shell {
          cargoHomeBase = dev.cargoHomeBase;
          name = "rust-shell";
        }
      )
    ];
  };
}
