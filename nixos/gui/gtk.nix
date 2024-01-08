{ pkgs, lib, ... }:
let
  gSettingsKeySlashed = "org/gnome/desktop/interface";
  gSettings = {
    gtk-theme = "Adwaita";
    icon-theme = "Humanity-Dark";
    font-name = "Atkinson Hyperlegible 16";
    cursor-theme = "phinger-cursors";
    cursor-size = "48";
    toolbar-style = "icon";
    toolbar-icon-size = "large";
    font-antialiasing = "rgba";
    font-hinting = "slight";
    monospace-font-name = "Inconsolata Nerd Font Mono 16";
    document-font-name = "Atkinson Hyperlegible 16";
    enable-hot-corners = "false";
    color-scheme = "prefer-dark";
  };
  gtk3SettingsIni = {
    gtk-theme-name = "Adwaita";
    gtk-icon-theme-name = "Humanity-Dark";
    gtk-font-name = "Atkinson Hyperlegible 16";
    gtk-cursor-theme-name = "phinger-cursors";
    gtk-cursor-theme-size = builtins.toString 48;
    gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
    gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
    gtk-button-images = builtins.toString 0;
    gtk-menu-images = builtins.toString 0;
    gtk-enable-event-sounds = builtins.toString 1;
    gtk-enable-input-feedback-sounds = builtins.toString 0;
    gtk-xft-antialias = builtins.toString 1;
    gtk-xft-hinting = builtins.toString 1;
    gtk-xft-hintstyle = "hintslight";
    gtk-xft-rgba = "rgb";
    gtk-application-prefer-dark-theme = builtins.toString 1;
  };
in {
  config = {
    environment.systemPackages = with pkgs; [ phinger-cursors ];

    programs.dconf = {
      enable = true;
      profiles.user.databases = [{
        settings.${gSettingsKeySlashed} = gSettings;
        # lockAll prevents a user's settings from overriding the system's settings
        # https://help.gnome.org/admin/system-admin-guide/stable/dconf-lockdown.html.en
        # https://github.com/NixOS/nixpkgs/blob/a9bf124c46ef298113270b1f84a164865987a91c/nixos/modules/programs/dconf.nix#L123
        lockAll = true;
      }];
    };

    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        ${builtins.concatStringsSep "\n"
        (map ({ name, value }: "${name}=${value}")
          (lib.attrsToList gtk3SettingsIni))}
      '';
      "gtk-3.0/settings.ini".text = ''
        [Settings]
        ${builtins.concatStringsSep "\n"
        (map ({ name, value }: "${name}=${value}")
          (lib.attrsToList gtk3SettingsIni))}
      '';
      # this is for qt compat
      "xdg/gtk-2.0/gtkrc".text = ''
        gtk-theme-name = "Adwaita"
      '';
    };
  };
}
