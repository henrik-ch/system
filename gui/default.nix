{ pkgs, ... }:

{
  imports = [
    ./hyprland.nix
  ];
  
  nixpkgs.config.allowUnfreePredicate =
    package:
      builtins.elem (pkgs.lib.getName package) [ 
        "vscode" 
        "discord"
      ];

  fonts.packages = with pkgs; [
    google-fonts
    atkinson-hyperlegible
    (nerdfonts.override { fonts = [ "Inconsolata" ]; } )
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
  ];

  xdg.portal.enable = true;
}
