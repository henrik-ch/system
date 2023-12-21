{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    google-fonts
    atkinson-hyperlegible
    vollkorn
    inter
    source-sans
    source-serif
    (nerdfonts.override { fonts = [ "Inconsolata" "SourceCodePro" ]; })
    (callPackage ./drvs/de-aetna.nix { })
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Inconsolata Nerd Font Mono"
        "Source Code Pro Nerd Font"
        "Source Code Pro"
      ];
      serif = [ "Lora" "Vollkorn" "Source Serif Pro" ];
      sansSerif = [ "Atkinson Hyperlegible" "Inter" "Source Sans Pro" ];
    };
  };
}
