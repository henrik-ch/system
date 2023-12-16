{ pkgs, lib, config, ... }:
let
  interfaceKeySlashed = "org/gnome/desktop/interface";
  interfaceKeyDotted =
    builtins.replaceStrings [ "/" ] [ "." ] interfaceKeySlashed;
  interfaceSettings = {
    font-antialiasing = "rgba";
    font-hinting = "full";
    gtk-theme = "Adwaita";
    color-scheme = "prefer-dark";
    font-name = "Atkinson Hyperlegible 16";
    cursor-theme = "phinger-cursors";
    monospace-font-name = "Inconsolata Nerd Font Mono 16";
    document-font-name = "Atkinson Hyperlegible 16";
  };
in {

  options = {
    explicitSwayGSettings = lib.mkEnableOption "explicitSwaySettings";
    createGtk3SettingsIni = lib.mkEnableOption "createGtk3SettingsIni";
  };

  config = {
    environment.systemPackages = with pkgs; [
      phinger-cursors
      (if config.explicitSwayGSettings then
        (let
          # https://gitlab.gnome.org/GNOME/gsettings-desktop-schemas/-/blob/master/schemas/org.gnome.desktop.interface.gschema.xml.in?ref_type=heads
          schema = pkgs.gsettings-desktop-schemas;
          datadir = "${schema}/share/gsettings-schemas/${schema.name}";
        in writeScriptBin "sway-config-gtk" ''
          export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
          gnome_schema=org.gnome.desktop.interface
          ${builtins.concatStringsSep "\n" (map
            ({ name, value }: "gsettings set $gnome_schema ${name} '${value}'")
            (lib.attrsToList interfaceKeyDotted))}
        '')
      else
        writeScriptBin "sway-config-gtk" "")
    ];

    programs.dconf = {
      enable = true;
      profiles.user.databases = [{
        settings.${interfaceKeySlashed} = interfaceSettings;
        # lockAll prevents a user's settings from overriding the system's settings
        # https://help.gnome.org/admin/system-admin-guide/stable/dconf-lockdown.html.en
        # https://github.com/NixOS/nixpkgs/blob/a9bf124c46ef298113270b1f84a164865987a91c/nixos/modules/programs/dconf.nix#L123
        lockAll = true;
      }];
    };

    environment.etc = lib.mkMerge [
      # ({
      #   "dconf/db/local.d/locks/prefer-system" = let
      #     lockEntries = map
      #       (name: builtins.concatStringsSep "/" [ interfaceKeySlashed name ])
      #       (builtins.attrNames interfaceSettings);
      #   in { text = "${builtins.concatStringsSep "\n" lockEntries}"; };

      # })
      (lib.mkIf config.createGtk3SettingsIni {

        "xdg/gtk-3.0/settings.ini".text = ''
          [Settings]
          gtk-cursor-theme-name=phinger-cursors
          gtk-font-name=SF Pro Text 12
          gtk-icon-theme-name=Flat-Remix-Purple-Dark
          gtk-theme-name=mountain
        '';
      })
      {
        # this is for qt compat
        "xdg/gtk-2.0/gtkrc".text = ''
          gtk-theme-name = "mountain"
        '';
      }
    ];
  };
}
