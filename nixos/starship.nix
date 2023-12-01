{ pkgs, ... }:
let
  lib = pkgs.lib;
  # =======================================
  # picked from:
  # https://nixos.org/manual/nixpkgs/stable/#sec-functions-library-strings
  concatStrings = lib.strings.concatStrings;
  optionalString = lib.strings.optionalString;
  # toUpper = lib.strings.toUpper;

  replicate = lib.lists.replicate;
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

  createStylor = fg: bg: {
    inherit fg bg;
    emphases = "";
    __functor = self: txt:
      fmt self txt;
  };
  swapFgBg = stylor:
    (createStylor stylor.bg stylor.fg) // { inherit (stylor) emphases; };

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
    dimwhite = "#bfbfbf";
    red = "#ff0000";
    rose = "#ff6dd8";
    grey = "#8b8b8b";
    slate = "#31316c6f8531";
    green = "#68ff46";
    lime = "#a1d540";
    teal = "#00f2ff";
    tealblue0 = "#00D3FF";
    tealblue1 = "#00B5FF";
    tealblue2 = "#0096FF";
    blue = "#0077ff";
    lightsunny = "#fdff93";
    sunny = "#ffee00";
    sepia = "#ffcd44";
    peach = "#ff9500";
    beige = "#ffd191";
    flamingo = "#ff8686";
    sky = "#00b7ff";
    plumdim = "#812ba8";
    plum = "#a538d7";
    plumbright = "#c23eff";
    sapphire = "#209fb5";
    brown = "#D06B20";
  };
  colorsWith = with builtins;
    focusDef: palette:
      let
        hasBg = hasAttr "bg" focusDef;
        hasFg = hasAttr "fg" focusDef;
        focus =
          if hasBg && hasFg then
            abort "mkStylorDef cannot have both fg and bg as attrs"
          else if hasFg then
            let fg = focusDef.fg; in
            {
              n = fg;
              f = x: createStylor fg x;
            }
          else if hasBg then
            let bg = focusDef.bg; in
            {
              n = bg;
              f = x: createStylor x bg;
            }
          else
            abort "mkStylorDef does not have fg or bg as attrs";
        mkStylor = n: if focus.n != n then { "${n}" = focus.f n; } else { };
      in
      concatMapAttrs
        (
          n: v: mkStylor n
        )
        palette;
  colorsWithFg = fg: colorsWith { inherit fg; };
  colorsWithBg = bg: colorsWith { inherit bg; };
  uniformColors = palette:
    concatMapAttrs
      (
        n: v: {
          "${n}" = createStylor n n;
        }
      )
      palette;
  combinationColors = combiner: palette: concatMapAttrs
    (
      n: v: {
        "${n}" = combiner "${n}" palette;
      }
    )
    palette;
  paletteColors = palette: {
    uniform = uniformColors palette;
    withFg = combinationColors colorsWithFg palette;
    withBg = combinationColors colorsWithBg palette;
  };
  colors = paletteColors vivid_palette;

  # ========================================
  repeatSym = sym: n: concatStrings (replicate n sym);

  # ========================================
  gap = n: repeatSym " " n;

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
      style = let c = colors.withBg.black; in {
        canvas = colors.uniform.black;
        alert = bold c.red;
        warning = bold c.peach;
        info = bold c.white;
        ok = bold c.lime;
        attn = bold c.flamingo;
        dir = bold c.green;
        git = c.beige;
        gitLabel = bold c.beige;
        nix = c.sapphire;
        nixLabel = bold c.sapphire;
        host = bold c.blue;
        hostUserAt = colors.uniform.tealblue1;
        # let
        #   cu = colors.uniform;
        # in
        #   x: (cu.tealblue2 " ") + (cu.tealblue1 x) + (cu.tealblue0 " ");
        user = bold c.teal;
        plain = c.dimwhite;
        default = c.white;
        neutral = c.grey;
        diverged = bold c.peach;
      };
      timeTortoise = tortoise style.neutral;
      blank = style.canvas (gap 1);

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
      newLine = (x: suf "\n" x);
      optNewLine = x: opt (newLine x);
      concatStrSep = f: parts: builtins.concatStringsSep (f "") parts;
      concatStrMap = f: parts: concatStrings (map f parts);


      labelMid = stylor: swapFgBg stylor;
      labelStart = symL: stylor: x:
        (stylor symL) + (labelMid stylor x);
      labelEnd = symR: stylor: x:
        (labelMid stylor x) + (stylor symR);
      label = syms: stylor: x:
        (labelStart syms.l stylor x) + (labelEnd syms.r stylor "");

      #capsule = shell_stylor: content_stylor: x: "" "" shell_stylor
      #(content_stylor x);

      rounded = symPair "" "";
      roundedStart = labelStart rounded.l;
      roundedWrap = label rounded; #(shell "" "") shell_stylor content_stylor x;
      roundedEnd = labelEnd rounded.r;
      diamond = symPair "" "";
      diamondWrap = label diamond;
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
              (roundedStart style.host "$hostname ")
              #(style.hostUserAt " ")
              (roundedEnd style.user " $username")
            ];
            sudo = sufSep "$sudo";
            time_host_user_dir =
              (
                "\n" + (opt sudo) + concatStrSep preSep
                  [
                    host_user
                    "$directory"
                  ]
              ) +
              (
                concatStrMap optPreSep
                  [
                    (style.default "$envVar")
                    (style.default "$jobs")
                  ]
              ) + concatStrings [ "$fill" "$time" ];
            git_info =
              concatStrSep
                preSep
                [
                  "$git_branch"
                  "$git_commit"
                  "$git_status"
                  "$git_metrics"
                  "$git_state"
                ]
              + style.gitLabel (preSep diamond.l + rounded.r);
          in
          concatStrMap
            optNewLine
            (
              [
                "$cmd_duration"
                time_host_user_dir
                git_info
                "$nix_shell"
              ] ++
              [
                "$character"
              ]
            );

        cmd_duration = {
          format = style.default "󱞩  took $duration ✦";
          show_notifications = true;
          min_time = 0;
          notification_timeout = 3500;
        };

        time =
          {
            format = timeTortoise style.neutral "$time";
            use_12hr = false;
            disabled = false;
            style = "";
          };

        hostname = {
          format = "$hostname";
          ssh_only = false;
          disabled = false;
          style = "";
        };

        username = {
          format = "$user";
          show_always = true;
          style_user = "";
        };

        directory =
          let
            read_only = optSufSep (style.attn "$read_only");
          in
          {
            format = read_only + (style.dir "$path");
            read_only = "🔒";
            truncation_symbol = "…/";
            truncate_to_repo = false;
            style = "";
          };

        git_branch =
          let
            git_sym = roundedStart style.gitLabel "$symbol";
            branch = style.gitLabel "$branch";
            remote = opt (style.git ":$remote_branch");
          in
          {
            format = concatStrSep preSep [
              git_sym
              branch
              remote
            ];
            symbol = "git";
            only_attached = false;
            style = "";
          };

        git_commit =
          let
            hash = style.neutral "$hash";
            tag = optSufSep (style.neutral "$tag");
          in
          {
            format = hash + tag;
            tag_symbol = "󰃀";
            only_detached = false;
            style = "";
          };

        git_status =
          let
            defaultCount = "$count";
            _countSym = count: color: sym: color "${sym}${count}";
            countSym = _countSym defaultCount;
            aheadArrow = "🠙";
            behindArrow = "🠛";
            web = preSep (diamondWrap style.gitLabel "󰖟");
            local = (diamondWrap style.gitLabel "󰋞");
            ahead_behind = opt "${web} $ahead_behind";
            status = opt (
              (preSep "${local}") + (
                concatStrMap
                  preSep
                  [
                    "$conflicted"
                    "$stashed"
                    "$deleted"
                    "$renamed"
                    "$modified"
                    "$staged"
                    "$untracked"
                    "$typechanged"
                  ]
              )
            );
            symbols =
              {
                ahead = countSym style.ok aheadArrow; #🟘
                behind = countSym style.alert behindArrow; #🟗
                diverged = concatStrings [
                  (style.info "$ahead_count ")
                  (style.ok aheadArrow)
                  (style.alert behindArrow)
                  (style.info " $behind_count")
                  # (_revCountSym "$ahead_count" style.ok aheadArrow)
                  # (_revCountSym "$behind_count" style.alert behindArrow)
                ];
                up_to_date = style.ok "󰓦"; #🙫
                conflicted = countSym style.alert "⮻"; #⩙⪤1⮺🗗 ⮼⧉❐❏⧉⮻
                stashed = countSym style.info ""; #⧈🞔
                deleted = countSym style.attn ""; #⊠⬚
                renamed = countSym style.attn ""; #⛋
                staged = countSym style.ok "⭱"; #▤▧▩⛶🞏
                typechanged = countSym style.info "󱡔"; #◨󱎖
                modified = countSym style.attn "●"; #⊡▩
                untracked = countSym style.alert "?"; #⌑⛶
              };
          in
          {
            format = "${ahead_behind}${status}";
            style = "";
          } // symbols;

        git_state =
          let
            state_symbol = diamondWrap style.gitLabel "󰇘";
            state = preSep (style.warning "$state");
            progress =
              opt (preSep (style.warning "$progress_current/$progress_total"));
          in
          {
            format =
              opt (
                concatStrings
                  [
                    state_symbol
                    state
                    progress
                  ]
              );
            style = "";
          };

        git_metrics = {
          format = opt (concatStrSep preSep [
            (style.ok "$+$added")
            (style.attn "-$deleted")
          ]);
        };

        nix_shell =
          let
            impure_msg = style.alert "impure";
            pure_msg = style.ok "pure";
            unknown_msg = style.attn "unkown status";
          in
          {
            symbol = roundedWrap style.nixLabel "nix";
            format = "$symbol(${preSep "$state"})( ${style.nix "\($name\)"})";
            inherit impure_msg pure_msg unknown_msg;
            style = "";
          };
      }; # // starship_config;
    };
}
