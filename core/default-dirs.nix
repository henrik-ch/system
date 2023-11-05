{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
  ];

  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=
    DOWNLOAD=downloads
  '';
}
