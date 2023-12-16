{ pkgs, lib, ... }: {
  imports = [
    ./chat.nix
    ./editing.nix
    ./fonts.nix
    ./gtk.nix
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
    google-fonts
    wayland
    glib
    xfce.thunar
    humanity-icon-theme
  ];

  security.pam.loginLimits = [{
    domain = "@users";
    item = "rtprio";
    type = "-";
    value = 1;
  }];

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
      #export WLR_RENDERER=vulkan
      extraSessionCommands = ''
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
      ];
    };
  };
  qt = {
    enable = true;
    style = "gtk2";
    platformTheme = "gtk2";
  };
}
