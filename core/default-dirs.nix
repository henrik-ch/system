{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  environment.etc."xdg/user-dirs.defaults".text = ''
    CONFIG_DIRS=config-sys
    CONFIG_HOME=config
    CACHE_HOME=cache
    DATA_HOME=local/share
    STATE_HOME=local/state
    DESKTOP=
    DOWNLOAD=downloads
  '';
}
