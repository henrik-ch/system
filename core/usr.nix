{pkgs, ...}: {
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
    shellAliases = {
      hl = "Hyprland";
      sy = "sway";
      _conf = "hx ~/nixos-conf";
      _core = "hx ~/nixos-conf/core/default.nix";
      _usr = "hx ~/nixos-conf/core/usr.nix";
      _wez = "hx ~/nixos-conf/home-common/.config/wezterm";
      _hx = "hx ~/nixos-conf/home-common/.config/helix/config.toml";
      _sy = "hx ~/nixos-conf/home-common/.config/sway";
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
      gs = "ls ; git status";
      gc = "git clone --recurse-submodules";
      gf = "git fetch";
      gm = "git merge";
      gpull = "git pull ; git submodule update --init --recursive";
      gfm = "git fetch ; git merge";
      gfp = "git fetch ; git pull";
      gd = "git diff";
      gp = "git push --recurse-submodules=check";
      gpod = "git push --recurse-submodules=on-demand";
      gsmr = "git submodule update --remote --rebase";
      gsmm = "git submodule update --remote --merge";
      cd = "f() {
                cd $1;
                echo \"\";
                git status 2> /dev/null;
                echo \"\";
                lsd -a;
              };f";
    };
  };

  programs.gnupg = {
    agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };

  # Shell theme with Catpuccin and Starship Prompt
  programs.starship = let
    star_sty = {
      fg,
      bg,
      sty ? "",
    }: "(fg:${fg} bg:${bg} ${sty})";
    star_fmt = content: "[${content}]";
    start_sym = "";
    end_sym = "";
    status_sym = "●";
    gap = " ";
    # thanks to: https://github.com/catppuccin/catppuccin
    palette_colors = {
      black = "#000000";
      white = "#ffffff";
      light_grey = "#6c6f85";
      dark_grey = "#1e1e1f";
      green = "#40a02b";
      yellow = "#dfc51d";
      peach = "#fe640b";
      flamingo = "#dd7878";
      sky = "#04a5e5";
      mauve = "#9755ed";
      sapphire = "#209fb5";
    };
    star_content = content: {
      fg,
      bg,
      sty ? "",
    }: "${star_fmt content}${star_sty {
      inherit fg bg sty;
    }}";
    block_start = fg: bg: (star_content start_sym {
      inherit fg bg;
    });
    block_end = fg: bg: (star_content end_sym {
      inherit fg bg;
    });
    block_content = content: {
      fg,
      bg,
      sty,
    }:
      star_content content {
        inherit fg bg sty;
      };
    block = content: {
      fg,
      bg ? "dark_grey",
      sty ? "",
    }: "${block_start bg palette_colors.black}${block_content content {inherit fg bg sty;}}${block_end bg palette_colors.black}";
  in {
    enable = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      # Inserts a blank line between shell prompts
      add_newline = true;
      # Other config here

      # Only supported by fish and zsh
      right_format = ''
      '';

      palette = "custom_catpuccin";

      palettes.custom_catpuccin = palette_colors;

      # format = ''
      #   $status\
      #   $host\
      #   $usr\
      # '';

      format = "$time $hostname $username $directory $git_branch $git_commit$git_state$git_status$git_metrics  $all";
      # $directory\
      # $git_branch\
      # $git_status\
      # $git_metrics\
      # $git_commit\
      # $fill\
      # $env_var\
      # $custom\
      # $cmd_duration\
      # $sudo\
      # $line_break\
      # $nix_shell\
      # $jobs\
      # $character\

      hostname = {
        format = block "$hostname" {fg = "yellow";};
        ssh_only = false;
        disabled = false;
      };

      username = {
        format = block "$user" {
          fg = "peach";
        };
        show_always = true;
      };

      directory = {
        format = "${block "$read_only$path" {
          fg = "sky";
          bg = "dark_grey";
          sty = "bold";
        }}";
        read_only = " 🔒 ";
        truncation_symbol = "…/";
      };

      git_branch = {
        format = block "$symbol$branch(:$remote_branch)" {
          fg = "mauve";
          sty = "bold";
        };
        only_attached = true;
      };

      git_commit = {
        format = block "$tag$hash" {
          fg = "mauve";
          sty = "bold";
        };
      };

      git_status = {
        format = block "\\[$all_status$ahead_behind\\]" {
          fg = "red";
          sty = "bold";
        };
      };

      git_state = {
        format = "\(${(block "$state( $progress_current/$progress_total)" {
          fg = "yellow";
          sty = "bold";
        })}\)";
      };

      time = {
        format = block "$time" {
          fg = "black";
          bg = "light_grey";
        };
        use_12hr = false;
        disabled = false;
      };
    };
  };

  security.pam.services.bzm3r.enableGnomeKeyring = true;
  programs.seahorse.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    convos.enable = true;
  };

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

    (callPackage ./btrfs-rec.nix {})
    #new pkg
  ];

  users = {
    defaultUserShell = "${pkgs.zsh}/bin/zsh";

    users.bzm3r = {
      isNormalUser = true;
      home = "/home/bzm3r";
      extraGroups = ["wheel" "networkmanager" "video" "rcontent_block" "libvirtd"];
      useDefaultShell = true;
    };
  };
}
