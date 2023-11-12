{ pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    mako 
    swayosd
    wlr-which-key
    waybar
    
    libsForQt5.polkit-kde-agent
    qt6Packages.qt6ct
    libsForQt5.qt5ct    
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    gnome.dconf-editor
    
    wofi
    gnome.nautilus

    wl-clipboard
    
    fontfinder
    font-manager    
  ];

  gtk.iconCache.enable = true;
  programs.dconf.enable = true;  
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
}
