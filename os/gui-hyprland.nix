{ pkgs, ... }:

{
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.hyprland = {
    enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    dunst
    swayosd
    wlr-which-key
    waybar
    libsForQt5.polkit-kde-agent
    libsForQtf5.qt5ct
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    qt6Packages.qt6ct
    lxappearance
    kickoff
    dolphin
  ];
}
