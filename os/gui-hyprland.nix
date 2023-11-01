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
    pkgs.libsForQt5.polkit-kde-agent
    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qt5.qtwayland
    pkgs.qt6.qtwayland
    pkgs.qt6Packages.qt6ct
    lxappearance
    kickoff
    dolphin
  ];
}
