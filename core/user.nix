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
            userconf = "hx ~/nixos-conf/core/user.nix";
            hyprconf = "hx ~/nixos-conf/home/.config/hypr/hyprland.conf";
            srebuild = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
            supgrade = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #hardware
    tlp
    thermald
    acpilight
    git

    helix # no vim or emacs allowed

    # archives
    zip
    xz
    unzip
    p7zip

    #security
    gnupg
    pass
    libsecret
    pinentry

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

    zsh-powerlevel10k
  ];

  users = {
    defaultUserShell = "${pkgs.zsh}/bin/zsh";

    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extraGroups = [ "wheel" "networkmanager" ];
      useDefaultShell = true;

      packages = with pkgs; [
        rustup
        mold
        sccache

        nil
        vscode
        discord

        gh
        git-credential-oauth
        wakatime

        # for gui
        dunst
        swayosd
        wlr-which-key
        waybar
        libsForQt5.polkit-kde-agent
        pkgs.libsForQt5.qt5ct
        pkgs.libsForQt5.qt5.qtwayland
        pkgs.qt6.qtwayland
        pkgs.qt6Packages.qt6ct
        nwg-look
        wofi
        dolphin
      ];
    };
  };
}
