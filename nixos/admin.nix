{ pkgs, lib, config, ... }: {
  config = {
    environment.systemPackages = with pkgs; [
      (callPackage config.sources.create_script {})
    ];
  };
}
