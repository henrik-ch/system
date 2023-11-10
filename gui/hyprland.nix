{ pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
  };

  gtk.iconCache.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [
    mako 
    swayosd
    wlr-which-key
    waybar
    
    libsForQt5.polkit-kde-agent
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    
    wofi
    dolphin

    bibata-cursors
    wl-clipboard
    
    fontfinder
    font-manager    
  ];

  programs.dconf.enable = true;
}
