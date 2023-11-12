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
            sy = "sway";
            _conf = "hx ~/nixos-conf";
            _core = "hx ~/nixos-conf/core/default.nix";
            _usr = "hx ~/nixos-conf/core/usr.nix";
            _wez = "hx ~/nixos-conf/home/.wezterm.lua";
            _hx = "hx ~/nixos-conf/home/.config/helix/config.toml";
            _hl = "hx ~/nixos-conf/home/.config/hypr/hyprland.conf";
            _sy = "hx ~/nixos-conf/home/.config/sway/config";
            _nhl = "hx ~/nixos-conf/gui-hyprland.nix";
            _nsy = "hx ~/nixos-conf/gui-sway.nix";
            _re = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
            _up = "cd /home/bzm3r/nixos-conf ; sudo nix flake update ; sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
            gpg-import = "gpg --import-options restore --import";
            _hist = "nix profile history --profile /nix/var/nix/profiles/system";
            _wipe = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
            _reboot = "sudo reboot -h now";
            _shutdown = "sudo shutdown -h now";
            ls = "lsd -a";
            cat = "bat";
        };
        autosuggestions = {
            enable = true;
            strategy = [ "history" "completion" ];
            async = true;
            highlightStyle = "fg=3";
        };
        enableLsColors = true;
        interactiveShellInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    };

    programs.gnupg = {
        agent = {
            enable = true;
            pinentryFlavor = "gtk2";
        };
    };

  security.pam.services.bzm3r.enableGnomeKeyring = true;
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;   
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
    
    vscode
    discord
    element-desktop
    ffmpeg

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
 ];

 users = {
    defaultUserShell = "${pkgs.zsh}/bin/zsh";

    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extraGroups = [ "wheel" "networkmanager" "video" "render" "libvirtd" ];
      useDefaultShell = true;
    };
  };
}
