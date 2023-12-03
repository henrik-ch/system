{ pkgs, ... }: {
  documentation.man.man-db.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search pkgname
  environment.systemPackages = with pkgs; [
    man-db # unix/linux is so, so bad
    man-pages

    efibootmgr
    compsize
    parted
    btrfs-progs
    f2fs-tools
    dosfstools
    e2fsprogs

    #hardware
    tlp
    thermald
    acpilight
    brightnessctl

    # utilities
    wget
    curl
    seatd
    ripgrep # recursively searches directories for a regex pattern
    bat # nicer cat
    lsd # nicer ls
    fzf # A command-line fuzzy finder
    file
    which
    fd
    broot
    lsd
    most
    systeroid
    sysz
    sd # nicer sed
    procs
  ];
}
