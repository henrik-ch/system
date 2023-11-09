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
            _conf = "hx ~/nixos-conf";
            _usr = "hx ~/nixos-conf/core/user.nix";
            _wez = "hx ~/nixos-conf/home/.wezterm.lua";
            _hx = "hx ~/nixos-conf/home/.config/helix/config.toml";
            _hl = "hx ~/nixos-conf/home/.config/hypr/hyprland.conf";
            _nhl = "hx ~/nixos-conf/gui/hyprland.nix";
            _re = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf ; exec zsh";
            _up = "sudo nixos-rebuild switch --flake /home/bzm3r/nixos-conf --upgrade ; exec zsh";
            gpg-import = "gpg --import-options restore --import";
            _hist = "nix profile history --profile /nix/var/nix/profiles/system";
            _wipe = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system";
            _reboot = "sudo reboot -h now";
            _shutdown = "sudo shutdown -h now";
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

  services.passSecretService.enable = true;
   
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
    pass

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
    element-desktop

    gh
    git-credential-oauth
    wakatime

    zsh-powerlevel10k
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
