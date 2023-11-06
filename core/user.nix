{ pkgs, ... }:

{
  documentation.man.man-db.enable = true;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting = {
            highlighters = [ "main" ];
        };
        shellAliases = {
            hl = "Hyprland";
            sysconf = "hx ~/nixos-conf";
            usrconf = "hx ~/nixos-conf/core/user.nix";
            wezconf = "hx ~/nixos-conf/home/.wezterm.lua";
            hlxconf = "hx ~/nixos-conf/home/.config/helix/config.toml";
            hyprconf = "hx ~/nixos-conf/home/.config/hypr/hyprland.conf";
            nix-hyprconf = "hx ~/nixos-conf/gui/hyprland.nix";
            nixrebuild = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
            nixupgrade = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
            nixhist = "nix profile history --profile /nix/var/nix/profiles/system";
            nixwipe = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
            ls = "lsd -a";
            cat = "bat";
        };
        autosuggestions = {
            strategy = [ "completion" "history" ];
            async = true;

        };
        enableLsColors = true;
        interactiveShellInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    programs.gnupg = {
        agent = {
            enable = true;
            enableBrowserSocket = true;
            pinentryFlavor = "tty";
        };
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.bzm3r.enableGnomeKeyring = true;
    
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #hardware
    tlp
    thermald
    acpilight
    gitFull

    helix # no vim or emacs allowed

    # archives
    zip
    xz
    unzip
    p7zip

    #security
    gnupg
    libsecret
    pinentry    
    lssecret

    #man
    man-db
    man-pages

    # various
    btrfs-progs
    f2fs-tools
    dosfstools
    e2fsprogs
    wget
    curl
    seatd

    # nice-to-haves
    ripgrep # recursively searches directories for a regex pattern
    bat # nicer cat
    lsd # nicer ls
    fzf # A command-line fuzzy finder
    file
    which
    tree
    zstd
    fd
    distrobox
    broot
    du-dust
    halp
    lsd
    most
    tealdeer
    systeroid

    nil
    vscode
    discord

    gh
    git-credential-oauth
    wakatime

    zsh-powerlevel10k

    # for hyprland
    dunst
    swayosd
    wlr-which-key
    waybar
    libsForQt5.polkit-kde-agent
    libsForQt5.qt5ct
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    qt6Packages.qt6ct
    nwg-look
    wofi
    dolphin

    font-finder
  ];

  users = {
    defaultUserShell = "${pkgs.zsh}/bin/zsh";

    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extraGroups = [ "wheel" "networkmanager" ];
      useDefaultShell = true;
    };
  };
}
