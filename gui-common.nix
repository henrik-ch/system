{pkgs, ...}: {
  fonts.packages = with pkgs; [
    google-fonts
    atkinson-hyperlegible
    vollkorn
    inter
    source-sans
    source-serif
    (nerdfonts.override {fonts = ["Inconsolata"];})
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Inconsolata"
        "Fira Code"
        "Source Code Pro"
      ];
      serif = [
        "Lora"
        "Vollkorn"
        "Source Serif Pro"
      ];
      sansSerif = [
        "Atkinson Hyperlegible"
        "Inter"
        "Source Sans Pro"
      ];
    };
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    xdg-utils
    wezterm
    firefox
    okular
    bibata-cursors
    google-fonts
    wayland
    glib
    gnome.dconf-editor
    gnome3.adwaita-icon-theme
    gnome.nautilus
  ];

  xdg.portal.enable = true;
}
