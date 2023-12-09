{ pkgs, ... }:
let
  config-gtk = import ./gtk.nix { inherit pkgs; };
  dbus-sway = import ./dbus-sway.nix { inherit pkgs; };
in {
  imports = [
    ./chat.nix
    ./editing.nix
    ./fonts.nix
    ./security.nix
    ./shell-scripts.nix
    ./terminal.nix
    ./vm.nix
  ];

  nixpkgs.config.allowUnfreePredicate = package:
    builtins.elem (pkgs.lib.getName package) [ "vscode" "discord" "gitkraken" ];

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

  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      dbus-sway
      config-gtk

      # eww-wayland
      waybar
      kickoff
      # wlr-which-key
      # swayest-workstyle
      swaylock
      swayidle
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
      wdisplays # tool to configure displays

      # show key code of key being pressed
      wev
    ];
  };
}
