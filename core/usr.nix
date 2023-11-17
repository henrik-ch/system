{ pkgs, config, ...}: {
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
    # thanks to: https://github.com/catppuccin/catppuccin
    palette_colors = {
      black = "#000000";
      white = "#ffffff";
      red = "#d20f39";
      pink = "#ff6dd8";
      light_grey = "#6c6f85";
      dark_grey = "#313131";
      green = "#40a02b";
      lime = "#a1d540";
      teal = "#179299";
      yellow = "#dfc51d";
      sepia = "#d9af3b";
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
    std_block_colors = { fg = "dark_grey"; bg = "black"; };
    inv_block_colors = { fg = std_block_colors.bg; bg = std_block_colors.fg; };
    block_start = fg: bg: (star_content start_sym {
      inherit fg bg;
    });
    block_end = fg: bg: (star_content end_sym {
      inherit fg bg;
    });
    block_content = content: {
      fg,
      bg ? "dark_grey" ,
      sty ? "",
    }:
      star_content content {
        inherit fg bg sty;
      };
    block =
      content:
      { fg, bg ? "dark_grey", sty ? "" }:
        let
          start = block_start bg palette_colors.black;
          end = block_end bg palette_colors.black;
        in
          "${start}${block_content content {inherit fg bg sty;}}${end}";
    # multiblock =
    #   { contents, flank_fg ? "dark_grey", flank_bg ? "black", flank_sty ? "" }:
    #     let
    #       flank_styling = { fg = flank_fg; bg = flank_bg; sty = flank_sty; };
    #       start = block_start flank_styling;
    #       end = block_end flank_styling;
    #     in
    #   "${start}${builtins.foldl' (l: r: "${block_content l.content l.styling
    #   }${r}") "" contents }${end}";
    semicircle_connectors = block_content "" std_block_colors;
    trapezoidal_connectors = let connector_gap = block_content " " std_block_colors; trapezoidal_transition = block_content "" inv_block_colors; in "${connector_gap}${trapezoidal_transition}${connector_gap}" ;
    block_connector = semicircle_connectors;
    start = block_start "dark_grey" "black";
    end = block_end "dark_grey" "black";
  in {
    enable = true;

    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      # Inserts a blank line between shell prompts
      add_newline = false;
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

      format = "$cmd_duration\n\n$time $hostname${block_connector}$username $directory ${start}$git_branch${block_connector}$git_commit${block_connector}$git_status${block_connector}$git_metrics$git_state${end}\n$character";
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
        format = block_content "${start}$hostname" {fg = "yellow";};
        ssh_only = false;
        disabled = false;
      };

      username = {
        format = block_content "$user${end}" {
          fg = "peach";
        };
        show_always = true;
      };

#       [custom.foo]
# command = 'echo foo' # shows output of command
# detect_files = ['foo'] # can specify filters but wildcards are not supported
# when = ''' test "$HOME" = "$PWD" '''
# format = ' transcending [$output]($style)'

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
        format = "${block_content "$symbol$branch(:$remote_branch)" {
          fg = "mauve";
          sty = "bold";
        }}";
        only_attached = true;
      };

      git_commit = {
        format = "${block_content "$tag$hash" {
          fg = "mauve";
          sty = "bold";
        }}";
        tag_symbol = "${block_content "🏷" { fg = "mauve"; sty = "bold"; }}";
        only_detached = false;
      };

      git_status = let ahead_arrow = "↑"; behind_arrow = "↓"; alert = "red"; warning = "peach"; info = "yellow"; ok = "lime"; in {
        format = "$ahead_behind$conflicted$stashed$deleted$renamed$modified$typechanged$staged$untracked"; #
        # ===
        # $ahead_behind (repo relative) parts
        ahead = block_content "${ahead_arrow} $count" { fg = ok; };
        behind = "${block_connector}${block_content "${behind_arrow} $count" { fg = alert; }}";
        diverged = block_content "${ahead_arrow} $ahead_count ⎇ ${behind_arrow} $behind_count" { fg = warning; };
        up_to_date = block_content "∼" { fg = ok; };
        # =====
        # other parts
        conflicted = block_content "${block_connector}⇋ $count" { fg = warning; };
        untracked = "${block_connector}${block_content "! $count" { fg = warning; }}";
        stashed = "${block_connector}${block_content "⫰⇠ $count" { fg = info; }}";
        deleted = "${block_connector}${block_content "x $count" { fg = warning; }}";
        renamed = "${block_connector}${block_content " $count" { fg = info; }}";
        staged = "${block_connector}${block_content "⇡ $count" { fg = ok; }}";
        typechanged = "${block_connector}${block_content "" { fg = info; }}";
        modified = "${block_connector}${block_content "Δ $count" { fg = warning; }}";
      };

      git_metrics = {
        disabled = false;
        format = "${block_content "+$added" { fg = "lime"; }}${block_content "-$deleted" { fg = "pink"; }}";
      };

      git_state = {
        format = "${(block_content " \\($state( $progress_current/$progress_total)\\)" {
          fg = "yellow";
          sty = "bold";
        })}";
      };

      time = {
        format = block "$time" {
          fg = "black";
          bg = "light_grey";
        };
        use_12hr = false;
        disabled = false;
      };
# min_time 	2_000 	Shortest duration to show time for (in milliseconds).
# show_milliseconds 	false 	Show milliseconds in addition to seconds for the duration.
# format 	'took [$duration]($style) ' 	The format for the module.
# style 	'bold yellow' 	The style for the module.
# disabled 	false 	Disables the cmd_duration module.
# show_notifications 	false 	Show desktop notifications when command completes.
# min_time_to_notify 	45_000 	Shortest duration for notification (in milliseconds).
# notification_timeout 		Duration to show notification for (in milliseconds). If unset, notification timeout will be determined by daemon. Not all notification daemons honor this option.
      cmd_duration = {
        format = "󱞩 $duration✦";#❱🙫🙪✦❚🙿
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
