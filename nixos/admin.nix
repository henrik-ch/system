{ pkgs, lib, config, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      (callPackage config.sources.rust-shell {
        name = "rust";
        inherit (config) cargoHomeBase;
      })
      (callPackage config.sources.create_script)
    ];
  };
}
