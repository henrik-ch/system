{pkgs, ...}: let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme 'Adwaita'
    '';
  };
in {
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

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  security.pam.loginLimits = [
    {
      domain = "@users";
      item = "rtprio";
      type = "-";
      value = 1;
    }
  ];

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
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      brightnessctl
      eww-wayland
      waybar
      dbus-sway-environment
      configure-gtk
      kickoff
      wlr-which-key
      swayest-workstyle
      swaylock
      swayidle
      grim # screenshot functionality
      slurp # screenshot functionality
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
      wdisplays # tool to configure displays
    ];
  };
}
