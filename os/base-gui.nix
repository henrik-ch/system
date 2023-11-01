{ pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Inconsolata" "Fira Code" "Source Code Pro" ];
      serif = [ "Lora" "Vollkorn" "Source Serif Pro" ];
      sansSerif = [ "Atkinson Hyperlegible" "Inter" "Source Sans Pro" ];
    };
  };

  # List packages installed in system profile
  environment.systemPackages = with pkgs; [
    wezterm
    firefox
    okular
    helix
    corefonts
    (nerdfonts.override { fonts = [ "Inconsolata" ]; })
  ];

  xdg.portal.enable = true;
}
