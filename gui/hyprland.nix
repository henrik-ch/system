{ pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.systemPackages = with pkgs; [
    dunst 
    swayosd
    wlr-which-key
    waybar
    libsForQt5.polkit-kde-agent
    
   libsForQt5.qt5.qtwayland
    qt6.qtwayland
   
    nwg-look
    wofi
    dolphin

    gtk3
    gtk4

    glib.bin
    gnome3.adwaita-icon-theme
    wl-clipboard

    fontfinder
    font-manager    
  ];

  programs.dconf.enable = true;

  # it seems that programs to provide basic functionality
  # for hyprland must be installed at a user level
  # otherwise we would have to use sudo 
}
