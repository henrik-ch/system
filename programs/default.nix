{ pkgs, ...}: {
  imports = [
    ./starship.nix
    ./aliases.nix
    ./gui.nix
  ];

  documentation.man.man-db.enable = true;

  nixpkgs.config.allowUnfreePredicate = package:
    builtins.elem (pkgs.lib.getName package) [
      "vscode"
      "discord"
      "gitkraken"
    ];

  programs.zsh = {
    enable = true;
    histSize = 1000;
    histFile = "~/.histfile";
    enableCompletion = true;
    enableGlobalCompInit = true;
    syntaxHighlighting = {
      highlighters = ["main"];
    };
    autosuggestions = {
      enable = true;
      strategy = ["history" "completion"];
      async = true;
      highlightStyle = "fg=3";
    };
    enableLsColors = true;
    interactiveShellInit = ''
      eval "$(direnv hook zsh)"
    '';
  };

  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };

  security.pam.services.bzm3r.enableGnomeKeyring = true;
  programs.seahorse.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    convos.enable = true;
  };

  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    efibootmgr
    compsize
    parted

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
    sysz
    sd
    procs

    nil
    nixpkgs-fmt

    vscode
    discord
    element-desktop
    ffmpeg
    gitkraken

    gh
    git-credential-oauth
    wakatime

    qemu
    libvirt
    virt-manager

    zsh-powerlevel10k

    eureka-ideas
    taskwarrior
    timewarrior

    brightnessctl
    wev

    (callPackage ./custom-derivations/btrfs-rec.nix {})
    (callPackage ./custom-derivations/de-aetna.nix {})
    #new pkg
  ];
}
