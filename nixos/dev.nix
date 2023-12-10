{ pkgs, lib, config, ... }: {
  options = {
    dev.cargoHomeBase = lib.options.mkOption {
      type = lib.types.str;
      example = "/home/alice";
      description = lib.mdDoc
        "Directory where $CARGO_HOME and $SCCACHE_DIR will be placed for a Rust shell";
    };
  };

  config = let
    rust-shell = (import config.sources.rust-shell) {
      name = "rust-shell";
      cargoHomeBase = config.dev.cargoHomeBase;
    };
  in {
    environment.systemPackages = with pkgs; [
      helix # no vim or emacs allowed
      shellcheck
      elfutils
      statix
      rust-shell
    ];
  };
}
