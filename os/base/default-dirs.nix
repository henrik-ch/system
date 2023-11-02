{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  environment.etc."xdg/user-dirs.defaults".text = ''
    CONFIG_DIRS=$HOME/config-sys
    CONFIG_HOME=$HOME/config
    CACHE_HOME=$HOME/cache
    DATA_HOME=$HOME/local/share
    STATE_HOME=$HOME/local/state
    DESKTOP=$HOME
    DOWNLOAD=$HOME/downloads
    TEMPLATES=$HOME/templates
    PUBLICSHARE=$HOME/public
    DOCUMENTS=$HOME
    MUSIC=$HOME/media
    PICTURES=$HOME/media
    VIDEOS=$HOME/media
  '';
}
