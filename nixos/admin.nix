{ pkgs, config, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      (callPackage config.sources.mkscript {})
    ];
  };
}
