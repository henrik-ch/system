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
            # for now, nothing
        };
        autosuggestions = {
            strategy = [ "completion" "history" ];
            highlightStyle = {
                fg = "dim grey";
            };
            async = true;

        };
        enableLsColors = true;
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
    zsh-powerlevel10k
    broot
    du-dust
    halp
    lsd
    most
    tealdeer
    systeroid
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
        git-credential-manager

        wakatime
      ];
    };
  };
}
