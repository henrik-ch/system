inputs@{ ... }:
with (import ./fmt.nix inputs);
with (import ./useful.nix inputs);
with (import ./lib_imports.nix inputs);
with (import ./spacers.nix inputs);
with (import ./symbols.nix inputs);
with (import ./colors.nix inputs);
with builtins;
let
  boldSwapDefault = emphasize (swapStylorColors defaultStylor) "bold";
  smoothTightCap = _smoothTightCap defaultStylor;
in
{
  programs.starship = {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      # Inserts a blank line between shell prompts
      add_newline = false;
      # Other config here

      # Only supported by fish and zsh
      right_format = ''
      '';

    palette = "vivid";
    palettes.vivid = vivid_palette;

    format = "\n$cmd_duration\n\n$time$hostname$username$directory $git_branch$git_commit$git_status$git_metrics$git_state\n$character";
    #   # $directory\
    #   # $git_branch\
    #   # $git_status\
    #   # $git_metrics\
    #   # $git_commit\
    #   # $fill\
    #   # $env_var\
    #   # $custom\
    #   # $cmd_duration\
    #   # $sudo\
    #   # $line_break\
    #   # $nix_shell\
    #   # $jobs\
    #   # $character\

    cmd_duration = {
      format = "󱞩  took $duration✦";
      show_notifications = true;
      #min_time_notify = 45_000; # in ms
    };

    time = {
      format = smoothTightCap boldSwapDefault "$time";
      use_12hr = false;
      disabled = false;
    };

      # hostname = {
      #   format = join_strs full_capsule [{
      #     txt = "$hostname";
      #     color = "yellow";
      #   }];
      #   ssh_only = false;
      #   disabled = false;
      # };

      # username = {
      #   format = join_strs full_capsule [{
      #     txt = "$user";
      #     color = "peach";
      #     emphases = "bold";
      #   }];
      #   show_always = true;
      # };

      # directory = {
      # hostname = {
      #   format = join_strs full_capsule [{
      #     txt = "$hostname";
      #     color = "yellow";
      #   }];
      #   ssh_only = false;
      #   disabled = false;
      # };

      # username = {
      #   format = join_strs full_capsule [{
      #     txt = "$user";
      #     color = "peach";
      #     emphases = "bold";
      #   }];
      #   show_always = true;
      # };

      # directory = {
      #   format = join_strs full_capsule [{
      #     txt = "$read_only$path";
      #     color = "sky";
      #     emphases = "bold";
      #   }];
      #   read_only = " 🔒 ";
      #   truncation_symbol = "…/";
      # };

      # git_branch = {
      #   format = join_strs start_capsule [{
      #     txt = "$symbol$branch(:$remote_branch)";
      #     color = "mauve";
      #     emphases = "bold";
      #   }];
      #   only_attached = false;
      # };

      # git_commit = {
      #   format = join_strs full_capsule [{
      #     txt = "$tag$hash";
      #     color = "mauve";
      #     emphases = "bold";
      #   }];
      #   tag_symbol = "🏷";
      #   only_detached = false;
      # };

      # git_status =
      #   let
      #     ahead_arrow = "↑";
      #     behind_arrow = "↓";
      #     alert = "red";
      #     warning = "peach";
      #     info = "yellow";
      #     ok = "lime";
      #   in {
      #     format = "$ahead_behind$conflicted$stashed$deleted$renamed$modified$typechanged$staged$untracked"; #
      #     # ===
      #     # $ahead_behind (repo relative) parts
      #     ahead = join_strs tight_round_no_end [ { txt = "${ahead_arrow}$count"; fg = warning; } ];
      #     behind = capsule_txt tight_round [ (colored_sg "${behind_arrow} $count" { fg = alert; }) ] tight_round;
      #     diverged = capsule_txt tight_round [ (colored_sg "${ahead_arrow} $ahead_count" { fg = "ok"; }) (colored_sg "⎇" info) ("${behind_arrow} $behind_count" { fg = alert; }) ] tight_round;
      #     up_to_date = capsule_txt tight_round [ (colored_sg "∼" { fg = ok; }) ] tight_round;
      #     # =====
      #     # other parts
      #     conflicted = capsule_txt tight_round [ (colored_sg "${behind_arrow} $count" { fg = alert; }) ] tight_round;
      #     stashed = "${str_circ_tight}${mk_fmt_g "⫰⇠ $count" { fg = info; }}";
      #     deleted = "${str_circ_tight}${mk_fmt_g "x $count" { fg = warning; }}";
      #     renamed = "${str_circ_tight}${mk_fmt_g " $count" { fg = info; }}";
      #     staged = "${str_circ_tight}${mk_fmt_g "⇡ $count" { fg = ok; }}";
      #     typechanged = "${str_circ_tight}${mk_fmt_g "" { fg = info; }}";
      #     modified = "${str_circ_tight}${mk_fmt_g "Δ $count" { fg = warning; }}";
      # };
      #   format = join_strs full_capsule [{
      #     txt = "$read_only$path";
      #     color = "sky";
      #     emphases = "bold";
      #   }];
      #   read_only = " 🔒 ";
      #   truncation_symbol = "…/";
      # };

      # git_branch = {
      #   format = join_strs start_capsule [{
      #     txt = "$symbol$branch(:$remote_branch)";
      #     color = "mauve";
      #     emphases = "bold";
      #   }];
      #   only_attached = false;
      # };

      # git_commit = {
      #   format = join_strs full_capsule [{
      #     txt = "$tag$hash";
      #     color = "mauve";
      #     emphases = "bold";
      #   }];
      #   tag_symbol = "🏷";
      #   only_detached = false;
      # };

      # git_status =
      #   let
      #     ahead_arrow = "↑";
      #     behind_arrow = "↓";
      #     alert = "red";
      #     warning = "peach";
      #     info = "yellow";
      #     ok = "lime";
      #   in {
      #     format = "$ahead_behind$conflicted$stashed$deleted$renamed$modified$typechanged$staged$untracked"; #
      #     # ===
      #     # $ahead_behind (repo relative) parts
      #     ahead = join_strs tight_round_no_end [ { txt = "${ahead_arrow}$count"; fg = warning; } ];
      #     behind = capsule_txt tight_round [ (colored_sg "${behind_arrow} $count" { fg = alert; }) ] tight_round;
      #     diverged = capsule_txt tight_round [ (colored_sg "${ahead_arrow} $ahead_count" { fg = "ok"; }) (colored_sg "⎇" info) ("${behind_arrow} $behind_count" { fg = alert; }) ] tight_round;
      #     up_to_date = capsule_txt tight_round [ (colored_sg "∼" { fg = ok; }) ] tight_round;
      #     # =====
      #     # other parts
      #     conflicted = capsule_txt tight_round [ (colored_sg "${behind_arrow} $count" { fg = alert; }) ] tight_round;
      #     stashed = "${str_circ_tight}${mk_fmt_g "⫰⇠ $count" { fg = info; }}";
      #     deleted = "${str_circ_tight}${mk_fmt_g "x $count" { fg = warning; }}";
      #     renamed = "${str_circ_tight}${mk_fmt_g " $count" { fg = info; }}";
      #     staged = "${str_circ_tight}${mk_fmt_g "⇡ $count" { fg = ok; }}";
      #     typechanged = "${str_circ_tight}${mk_fmt_g "" { fg = info; }}";
      #     modified = "${str_circ_tight}${mk_fmt_g "Δ $count" { fg = warning; }}";
      # };

      # git_state = {
      #   format = "${(mk_fmt_g " \\($state( $progress_current/$progress_total)\\)" {
      #     fg = "yellow";
      #     emphases = "bold";
      #   })}";
      # };

      # git_metrics = {
      #   format = "${str_circ_tight}${mk_fmt_g "+$added" { fg = "lime"; }}${mk_fmt_g "-$deleted" { fg = "pink"; }}";
      # };
    }; # // starship_config;
  };
}