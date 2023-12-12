{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ xdg-user-dirs ];

  environment.etc."xdg/user-dirs.defaults".text = ''
    XDG_DESKTOP_DIR="$HOME"
    XDG_DOCUMENTS_DIR="$HOME"
    XDG_DOWNLOAD_DIR="$HOME/downloads"
    XDG_MUSIC_DIR="$HOME"
    XDG_PICTURES_DIR="$HOME"
    XDG_PUBLICSHARE_DIR="$HOME"
    XDG_TEMPLATES_DIR="$HOME"
    XDG_VIDEOS_DIR="$HOME"
  '';
}