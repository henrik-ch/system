# thanks to:
#   * git.eisfunke.com/config/

{ pkgs, lib, inputs }:

{
  programs = {
    # a better traceroute
    mtr.enable = true;

    # enable git globally, config is at home level
    git = {
      enable = true;
      lfs.enable = true;
    };

    zsh.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    helix # no vim or emacs allowed
    rustup

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

    # networking tools
    mtr # A network diagnostic tool

    # misc
    file
    which
    tree
    zstd
    gnupg
  ];
}