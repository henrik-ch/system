{ pkgs, ... }:

{

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      config = {
        init = {
          defaultBranch = "main";
        };
        user = {
          name = "Brian Merchant";
          email = "bhmerchant@gmail.com";
        };
        commit = {
          gpgSign = true;
        };
        core = {
          editor = "hx";
        };
        credential = {
          helper = "manager";
          credentialStore = "gpg";
        };
      };
    };
  };

  documentation.man.man-db.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    tlp
    thermald
    acpilight

    helix # no vim or emacs allowed
    pass

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    bat # nicer cat
    lsd # nicer ls
    fzf # A command-line fuzzy finder
    file
    which
    tree
    zstd
    broot
    du-dust
    halp
    fd
    lsd
    most
    tealdeer
    systeroid

    man-db
    man-pages

    btrfs-progs
    f2fs-tools
    dosfstools
    e2fsprogs
    wget
    curl
    seatd

    distrobox
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
        git-credential-manager
        wakatime
      ];
    };
  };
}
