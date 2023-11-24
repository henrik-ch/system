{pkgs, ...}:
let
  lib = pkgs.lib;
  # =======================================
  # picked from:
  # https://nixos.org/manual/nixpkgs/stable/#sec-functions-library-strings
  concatStrings = lib.strings.concatStrings;
  optionalString = lib.strings.optionalString;
  hasPrefix = lib.strings.hasPrefix;
  # toUpper = lib.strings.toUpper;

  replicate = lib.lists.replicate;

  # mapAttrs = lib.attrsets.mapAttrs;
  concatMapAttrs = lib.attrsets.concatMapAttrs;

  # ========================================
  # ifThenElse = p: x: y: if p then x else y;
  isStrNonEmpty = with builtins; s: (stringLength s) > 0;
  ifNotEmptyThen = f: s: optionalString (isStrNonEmpty s) (f s);
  prefixIfNonEmpty = pre: ifNotEmptyThen (s: "${pre}${s}");
  # intoNewFunctor = existing_attrs: new_attrs: __functor:
  #   existing_attrs // new_attrs // {
  #   inherit __functor;
  # };
  # capitalize = with builtins;
  #   s:
  #     let
  #       head = (toUpper (substring 0 1 s));
  #       tail = (substring 1 (stringLength s) s);
  #     in
  #       "${head}${tail}";

  # ========================================
  fgFmt = fg: prefixIfNonEmpty "fg:" fg;
  bgFmt = bg: prefixIfNonEmpty " bg:" bg;
  emphasesFmt = emphases: prefixIfNonEmpty " " emphases;
  styleFmt = { fg, bg, emphases, ... }:
    ifNotEmptyThen (s: "(${s})")
      "${fgFmt fg}${bgFmt bg}${emphasesFmt emphases}";

  fmt = stylor: txt:
    ifNotEmptyThen (s: "[${txt}]${styleFmt stylor}")
      txt;

  createStylor = fg: bg: with builtins; {
    inherit fg bg;
    emphases = "";
    __functor = self: txt:
      if isAttrs txt then
        mapAttrs
          (
            name: val:
              if (hasPrefix "__" name) then
                ""
              else
                fmt self val
          )
          txt
      else
        fmt self txt;
  };

  emphasize = emphasis: stylor@{ emphases, ... }:
    stylor //
    {
      emphases =
      "${emphases}${prefixIfNonEmpty " " emphasis}";
    };

  # ========================================
  vivid_palette = {
    black = "#000000";
    white = "#ffffff";
    red = "#ff0037";
    rose = "#ff6dd8";
    silver = "#6c6f85";
    slate = "#313131";
    green = "#40a02b";
    lime = "#a1d540";
    teal = "#179299";
    yellow = "#ffdd00";
    sepia = "#d9af3b";
    peach = "#fe640b";
    flamingo = "#dd7878";
    sky = "#04a5e5";
    mauve = "#a87ae5";
    sapphire = "#209fb5";
  };
  colorStylor = fg: bg:
    if fg == bg then
      {
        "${fg}" = createStylor fg "";
      }
    else
      {
        "${fg}${bg}" = createStylor fg bg;
      };
  colors = concatMapAttrs
    (fg: fv:
      concatMapAttrs
        (bg: bv: colorStylor fg bg)
        vivid_palette
    )
    vivid_palette;

  # ========================================
  repeatSym = sym: n: concatStrings (replicate n sym);

  # ========================================
  gap = n: repeatSym " " n;
  # bar = n: repeatSym "―" n;
  # _block = stylor: n: _rptSym " " n stylor;
  # _bar = _rptSym "―";
  # gap = n: _gap n silverblack;
  # block = n: _block n blacksilver;
  noSpace = "";

  # ========================================
  symPair = l: r: {
    inherit l r;
  };

  smoothPair = symPair "" "";
  # _sharpPair = _symPair "" "";

  # smoothPair = _smoothPair silverblack;
  # sharpPair = _sharpPair blacksilver;

  # ========================================
  capsule = with builtins; stops: out_space: in_space: content:
    concatStrings
    (
      [
            out_space
            stops.l
            in_space
      ] ++
      (if isList content then content else [ content ]) ++
      [
        in_space
        stops.r
      ]
    );
  smoothCap = out_space:
    capsule
      (base smoothPair)
      out_space
      noSpace;
  smoothTightCap = smoothCap noSpace;
  smoothGapCap = smoothCap (tuiBg (gap 1));


  # =============================================

  tuiBg = colors.black;
  base = colors.slateblack;
  # parenthesize = x: "(${x})";
  bold = emphasize "bold";
  # timeCapStylor = bold colors.blackslate;
in
{
  programs.starship =
  let
    alert = bold colors.redslate;
    warning = bold colors.peachslate;
    info = bold colors.yellowslate;
    ok = bold colors.limeslate;
  in
  {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      # Inserts a blank line between shell prompts
      add_newline = false;
      # Other config here

      # Only supported by fish and zsh
      right_format = ''
      '';

      format =
        "$cmd_duration" +
        "\n$time" +
        "${smoothGapCap [
          (colors.yellowslate "$hostname")
          (colors.whiteslate "@")
          ((bold colors.peachslate) "$username")
          ]
        }" +
        "$directory" +
        "$git_branch" +
        "$git_commit" +
        "$git_status" +
        "$git_metrics" +
        "$git_state\n" +
        "$character";
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
        format = colors.whiteblack "󱞩  took $duration ✦";
        show_notifications = true;
        min_time = 2000;
        min_time_to_notify = 2000;
        notification_timeout = 3500;
      };

      palette = "vivid";
      palettes.vivid = vivid_palette;


      time = {
        format = smoothTightCap (
          bold colors.blackslate "$time"
        );
        use_12hr = false;
        disabled = false;
      };

      hostname = {
        format = "$hostname";
        ssh_only = false;
        disabled = false;
      };

      username = {
        format = "$user";
        show_always = true;
      };

      # hostname = {
      #   format = smoothGapCap (
      #     colors.yellowslate "$hostname"
      #   );
      #   ssh_only = false;
      #   disabled = false;
      # };

      # username = {
      #   format = smoothGapCap (
      #     (bold colors.peachslate) "$user"
      #   );
      #   show_always = true;
      # };

      directory = {
        format = smoothTightCap (
          (bold colors.skyslate) "$read_only$path"
        );
        read_only = " 🔒 ";
        truncation_symbol = "…/";
        truncate_to_repo = false;
      };

      git_branch = {
        format = smoothGapCap (
          (bold colors.mauveslate)
          "$symbol$branch(:$remote_branch)"
        );
        only_attached = false;
      };

      git_commit = {
        format = smoothTightCap (
          (bold colors.mauveslate)
          "$tag$hash"
        );
        tag_symbol = "🏷";
        only_detached = false;
      };

      git_status =
      let
        ahead_arrow = "🠙";
        behind_arrow = "🠛";
        diverged = "";
        up_to_date = "";
      in {
        format =
          "(${smoothTightCap [ "$ahead_behind" ]})" +
          "(${smoothTightCap [
            "$conflicted"
            "$stashed"
            "$deleted"
            "$renamed"
            "$modified"
            "$typechanged"
            "$staged"
            "$untracked"
          ]})"; #
        # ===
        # $ahead_behind (repo relative) parts
        ahead = warning "${ahead_arrow}$count";
        behind = alert "${behind_arrow}$count";
        diverged = (ok "${ahead_arrow}$ahead_count") + (info " ${diverged} ") + (alert "${behind_arrow}$behind_count");
        up_to_date = (ok up_to_date);
        # =====
        # other parts
        conflicted = alert "↹";
        stashed = "⫰󱞧$count";
        deleted = warning "$count";
        renamed = info "$count";
        staged = info "${ahead_arrow}$count";
        typechanged = info "";
        modified = alert "🠙$count";
      };

      git_state = {
        format = "(${smoothTightCap (
          info "\\($state( $progress_current/$progress_total)\\)"
        )})";
      };

      git_metrics = {
        format = "(${smoothTightCap [
          (ok "+$added")
          (bold (colors.roseslate) " -$deleted")
        ]})";
      };
    }; # // starship_config;
  };
}
