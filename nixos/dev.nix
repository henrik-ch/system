{ pkgs, lib, config, ... }: {
  options = {
    cargoHomeBase = lib.options.mkOption {
      type = lib.types.str;
      example = "/home/alfred";
      description = lib.mdDoc
        "Directory that will contain $CARGO_HOME and $SCCACHE_DIR for a Rust shell";
    };
    cabalHomeBase = lib.options.mkOption {
      type = lib.types.str;
      example = "/home/alfred";
      description =
        lib.mdDoc "Directory that will contain $CABAL_DIR for a Haskell shell";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      helix # no vim or emacs allowed
      shellcheck
      elfutils
      (callPackage config.sources.rust-shell {
        name = "rust";
        inherit (config) cargoHomeBase;
      })
      (callPackage config.sources.haskell-shell {
        name = "haskell";
        inherit (config) cabalHomeBase;
      })
    ];
  };
}
