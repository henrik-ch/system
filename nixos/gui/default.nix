{ pkgs, lib, ... }: {
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
    gnome.nautilus
  ];

  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

  # xdg.portal = {
  #   enable = true;
  #   wlr.enable = true;
  #   # gtk portal needed to make gtk apps happy
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };

  # enable sway window manager
  programs = {
    zsh.loginShellInit = ''
      if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ]; then
        exec sway
      fi
    '';
    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraSessionCommands = ''
        #export WLR_RENDERER=vulkan
        export SDL_VIDEODRIVER=wayland
        export LIBSEAT_BACKEND=logind
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      extraPackages = with pkgs; [
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
        phinger-cursors
        # gsettings
        # pkgs.writeTextFile {
        #   name = "sway-config-gtk";
        #   destination = "/share/icons/default/index.theme";
        #   executable = true;
        #   text = let
        #     schema = pkgs.gsettings-desktop-schemas;
        #     datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        #   in ''
        #     export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        #     gnome_schema=org.gnome.desktop.interface
        #     gsettings set $gnome_schema gtk-theme 'Adwaita-dark'
        #     gsettings set $gnome_schema color-scheme 'prefer-dark'
        #     gsettings set $gnome_schema cursor-theme '
        #   '';
        # }
      ];
    };
    dconf = {
      enable = true;
      profiles.user.databases = [{
        settings."org/gnome/desktop/interface" = {
          font-antialiasing = "rgba";
          font-hinting = "full";
          gtk-theme = "Adwaita-dark";
          color-scheme = "prefer-dark";
          font-name = "Atkinson Hyperlegible 16";
          cursor-theme = "phinger-cursors";
          monospace-font-name = "Inconsolata Nerd Font Mono 16";
          document-font-name = "Atkinson Hyperlegible 16";
        };
      }];
    };
  };
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };
}
