{ pkgs, lib, config, ... }: {
  options = {
    cargoHomeBase = lib.options.mkOption {
      type = lib.types.str;
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
      statix
      (callPackage config.sources.rust-shell {
        name = "rust-shell";
        inherit (config) cargoHomeBase;
      })
    ];
  };
}
