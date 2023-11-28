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
    ice = "#b3d7ff";
    white = "#ffffff";
    dimwhite = "#bfbfbf";
    red = "#ff0037";
    rose = "#ff6dd8";
    grey = "#8b8b8b";
    slate = "#31316c6f8531";
    green = "#68ff46";
    lime = "#a1d540";
    teal = "#00f2ff";
    lightsunny = "#fdff93";
    sunny = "#ffee00";
    sepia = "#ffcd44";
    peach = "#ff9500";
    lassi = "#ffd191";
    flamingo = "#ff8686";
    sky = "#00b7ff";
    plumdim = "#812ba8";
    plum = "#a538d7";
    plumbright = "#c23eff";
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
  # gap = n: _gap n greyblack;
  # block = n: _block n blackgrey;
  noSpace = "";

  # ========================================
  symPair = l: r: {
    inherit l r;
  };
  tortoise = shell_stylor: content_stylor: x: (shell_stylor "⦗ ") + (content_stylor x) + (shell_stylor " ⦘");

  # =============================================
  # timeCapStylor = bold colors.blackslate;
in
{
  programs.starship =
  let
    bold = emphasize "bold";

    c = with colors; {
      alert = bold red;
      warning = bold peach;
      info = bold sunny;
      ok = bold lime;
      attn = bold flamingo;
      dir = (bold colors.green);
      git = lassi;
      gitlabel = bold lassi;
      canvas = black;
      host = ice;
      user = teal;
      plain = dimwhite;
      default = white;
      timeTortoise = bold grey;
    };

    timeTortoise = tortoise c.timeTortoise;
    blank = c.canvas (gap 1);


    # op: string -> string
    # x: string -> string (an attrset that is a functor), OR string
    f = op: x:
      if builtins.isString x then
        op x
      else
        z: op (x (f z));

    pre = prefix: x: "${prefix}${x}";
    suf = suffix: x: "${x}${suffix}";

    # concatenable functions
    preSep = (x: pre blank x);
    sufSep = (x: suf blank x);
    preParen = (x: pre "(" x);
    sufParen = (x: suf ")" x);
    opt = (x: sufParen (preParen x));
    optPreSep = x: opt (preSep x);
    optSufSep = x: opt (sufSep x);
    newLine = (x: pre "\n" x);
    concatStrSep = f: parts: builtins.concatStringsSep (f "") parts;
    concatStrMap = f: parts: concatStrings (map f parts);
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


      palette = "vivid";
      palettes.vivid = vivid_palette;

      format =
        let
          host_user = concatStrings [
            (c.host "$hostname")
            (c.plain "@")
            (c.user "$username")
          ];
          sudo = sufSep "$sudo";
          time_host_user_dir =
            concatStrings
            (
              [
                (opt sudo)
                "$time"
                (newLine host_user)
              ]
             ) +
            (
              concatStrMap
              optPreSep
              [
                "$directory"
                (c.default "$envVar")
                (c.default "$jobs")
              ]
            );
          git_info =
            opt (
              concatStrSep
              optPreSep
              [
                "$git_branch"
                "$git_commit"
                "$git_status"
                "$git_metrics"
                "$git_state"
              ]
            );
        in
          concatStrSep
          newLine
          [
            "$cmd_duration"
            ""
            time_host_user_dir
            (opt git_info)
            "$nix_shell"
            "$character"
          ];

      cmd_duration = {
        format = c.default "󱞩  took $duration ✦";
        show_notifications = true;
        min_time = 2000;
      };


      time =
      {
        format = timeTortoise (bold c.timeTortoise) "$time";
        use_12hr = false;
        disabled = false;
      };

      hostname = {
        format = c.host "$hostname";
        ssh_only = false;
        disabled = false;
      };

      username = {
        format = c.user "$user";
        show_always = true;
      };

      directory =
      let
        read_only = optSufSep (c.attn "$read_only");
      in
      {
        format = read_only + (c.dir "$path");
        read_only = "🔒";
        truncation_symbol = "…/";
        truncate_to_repo = false;
      };

      git_branch =
      let
        git_sym = c.gitlabel "$symbol";
        branch = bold c.gitlabel "$branch";
        remote = opt (c.gitlabel ":$remote_branch");
      in {
        format = concatStrSep preSep [
          git_sym
          branch
          remote
        ];
        symbol = "";
        only_attached = false;
      };

      git_commit = let
        hash = colors.grey "$hash";
        tag = optSufSep (colors.grey "$tag");
      in {
        format = hash + tag;
        tag_symbol = "";
        only_detached = false;
      };

      git_status =
      let
        defaultCount = "$count";
        _countSym = count: color: sym: color (pre sym count);
        countSym = _countSym defaultCount;
        aheadArrow = "🠙";
        behindArrow = "🠛";
        sync = preSep (c.gitlabel "󰓦");
        local = c.gitlabel "\n󱞩 󰋞";
        ahead_behind = opt "${sync} $ahead_behind";
        status = opt (
          "${local}" + (
          concatStrSep preSep [
              "$conflicted"
              "$stashed"
              "$deleted"
              "$renamed"
              "$modified"
              "$staged"
              "$untracked"
              "$typechanged"
          ]
        ));
        symbols = {
          ahead = countSym c.ok aheadArrow;
          behind = countSym c.alert behindArrow;
          diverged = concatStrSep preSep [
            (_countSym "$ahead_count" c.ok aheadArrow)
            (c.info "")
            (_countSym "$behind_count" c.alert behindArrow)
          ];
          up_to_date = c.ok "";
          conflicted = countSym (tortoise c.alert c.alert "conflicts: ");#c.alert "↹";
          stashed = countSym (tortoise c.info c.info "stash: ");#c.info "";
          deleted = countSym (tortoise c.attn c.attn "del: ");#c.attn "";
          renamed = countSym (tortoise c.attn c.attn "mv: ");#c.attn "";
          staged = countSym (tortoise c.ok c.ok "staged: ");#c.ok "󰕒";
          typechanged = countSym (tortoise c.info c.info "typechange");#c.info "";
          modified = countSym (tortoise c.attn c.attn "mod: ");#c.attn "●";
          untracked = countSym c.alert "?";
        };
      in {
        format = "${ahead_behind}${status}";
      } // symbols;

      git_state = {
        format = opt (
          c.info "\\($state( $progress_current/$progress_total)\\)"
        );
      };

      git_metrics = {
        format = concatStrSep preSep [
          (c.ok "$+$added")
          (c.attn"-$deleted")
        ];
      };

      nix_shell =
      let
        impure = c.alert "$impure_msg";
        pure = c.ok "$pure_msg";
        unknown = c.attn "$unknown_msg";
      in {
        symbol = sufSep (bold colors.sky "nix-shell");
        format = concatStrSep preSep [
          impure
          pure
          unknown
        ];
        unknown_msg = "unknown status";
      };
    }; # // starship_config;
  };
}
