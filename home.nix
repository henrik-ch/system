{ config, pkgs, ... }:

{
  home.username = "bzm3r";
  home.homeDirectory = "/home/bzm3r";

 # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Brian Merchant";
    userEmail = "bhmerchant@gmail.com";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    wezterm
       
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    bat
    lsd
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    
    # misc
    file
    which
    tree
    zstd
    gnupg
  ];

  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
