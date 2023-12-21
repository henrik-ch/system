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

  # strMerger = import ./mergers.nix {
  #   inherit lib;
  #   isTerminal = builtins.isString;
  #   isIdentity = builtins.stringLength == 0;
  # };

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

  fmt = stylor: txt: ifNotEmptyThen (s: "[${txt}]${styleFmt stylor}") txt;

  __createStylor = fg: bg: {
    inherit fg bg;
    emphases = "";
    __functor = self: txt: fmt self txt;
  };
  createStylor = fg: bg:
    (__createStylor fg bg) // {
      swap = __createStylor bg fg;
    };

  emphasize = emphasis: stylor:
    let new_emphases = current: "${current}${prefixIfNonEmpty " " emphasis}";
    in lib.attrsets.recursiveUpdate stylor {
      emphases = new_emphases stylor.emphases;
      swap = { emphases = new_emphases stylor.swap.emphases; };
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
    orange = "#ffa844";
    sky = "#00b7ff";
    plumdim = "#812ba8";
    plum = "#a538d7";
    plumbright = "#c23eff";
    sapphire = "#209fb5";
    brown = "#D06B20";
    purplegrey = "#73528b";
  };
  colorsWith = with builtins;
    focusDef: palette:
    let
      hasBg = hasAttr "bg" focusDef;
      hasFg = hasAttr "fg" focusDef;
      focus = if hasBg && hasFg then
        abort "mkStylorDef cannot have both fg and bg as attrs"
      else if hasFg then
        let fg = focusDef.fg;
        in {
          n = fg;
          f = x: createStylor fg x;
        }
      else if hasBg then
        let bg = focusDef.bg;
        in {
          n = bg;
          f = x: createStylor x bg;
        }
      else
        abort "mkStylorDef does not have fg or bg as attrs";
      mkStylor = n: if focus.n != n then { "${n}" = focus.f n; } else { };
    in concatMapAttrs (n: v: mkStylor n) palette;
  colorsWithFg = fg: colorsWith { inherit fg; };
  colorsWithBg = bg: colorsWith { inherit bg; };
  uniformColors = palette:
    concatMapAttrs (n: v: { "${n}" = createStylor n n; }) palette;
  combinationColors = combiner: palette:
    concatMapAttrs (n: v: { "${n}" = combiner "${n}" palette; }) palette;
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
    l = if builtins.isAttrs l then l.l else l;
    r = if builtins.isAttrs r then r.r else r;
  };
  # =============================================
  # timeCapStylor = bold colors.blackslate;
in {
  programs.starship = let
    bold = emphasize "bold";
    style = (let c = colors.withBg.black;
    in {
      alert = bold c.red;
      warning = bold c.peach;
      info = bold c.white;
      ok = bold c.lime;
      attn = bold c.flamingo;
      canvas = colors.uniform.black;
      dir = bold c.purplegrey;
      git = c.beige;
      gitLabel = bold c.beige;
      nix = c.teal;
      nixLabel = bold c.teal;
      host = bold c.grey;
      hostusersep = colors.withFg.grey.dimwhite;
      # let
      #   cu = colors.uniform;
      # in
      #   x: (cu.tealblue2 " ") + (cu.tealblue1 x) + (cu.tealblue0 " ");
      user = bold c.dimwhite;
      plain = c.dimwhite;
      default = c.white;
      neutral = c.grey;
      diverged = bold c.peach;
      extraShellChars = bold c.plumbright;
      shell = c.sunny;
    }) // (let c = colors.withFg.black;
    in {
      prompt = bold c.white;
      promptS = bold c.green;
      promptF = bold c.red;
    });
    space = style.canvas (gap 1);

    pre = prefix: x: prefix + x;
    suf = suffix: x: x + suffix;

    # concatenable functions
    preSpace = (x: pre space x);
    sufSpace = (x: suf space x);
    preParen = (x: pre "(" x);
    sufParen = (x: suf ")" x);
    opt = (x: sufParen (preParen x));
    optSep = sep: x: (opt (sep (opt x)));
    optPreSpace = optSep (pre space);
    optSufSpace = optSep (suf space);

    newLine = (x: suf "\n" x);
    optNewLine = x: opt (newLine x);
    concatStrSep = f: parts: builtins.concatStringsSep (f "") parts;
    concatStrMap = f: parts: concatStrings (map f parts);

    printLabelDelim = { tag, stylor, delimPair, tag_stylor ? stylor.swap }:
      stylor (delimPair.l + (tag_stylor tag) + delimPair.r);
    makeDelim = left: right: stylor: tag:
      printLabelDelim {
        delimPair = (symPair left right);
        inherit stylor tag;
      };

    #capsule = shell_stylor: content_stylor: x: "" "" shell_stylor
    #(content_stylor x);
    rounded = symPair "" "";
    # blank = symPair " " " ";
    void = symPair "" "";
    forwardSlash = symPair "" "";
    # tortoise = symPair "⦗" "⦘";
  in {
    enable = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";
      # Inserts a blank line between shell prompts
      add_newline = false;
      # Other config here

      # Only supported by fish and zsh
      right_format = "";

      palette = "vivid";
      palettes.vivid = vivid_palette;

      format = let
        host_user = concatStrings [
          (makeDelim rounded void style.host "$hostname")
          ((createStylor style.host.fg style.user.fg) forwardSlash.r)
          (makeDelim void rounded style.user "$username")
        ];
        sudo = sufSpace "$sudo";
        git_info = opt ("$git_branch" + "$git_commit" + ("$git_status"
          + concatStrMap optPreSpace [ "$git_metrics" "$git_state" ])
          + preSpace (style.gitLabel (forwardSlash.l + rounded.r)));

        host_user_git_time =
          ("\n" + (opt sudo) + concatStrSep preSpace [ host_user "$directory" ])
          + (concatStrMap optPreSpace [
            (style.default "$envVar")
            (style.default "$jobs")
          ]) + concatStrings [ "$fill" "${git_info}" "$fill" "$time" ];
      in concatStrMap optNewLine ([
        "$cmd_duration"
        host_user_git_time
        (concatStrMap opt [ "$shell" "$nix_shell" "$shlvl" "$character" ])
      ]);

      character = let
        vimStyle = bold style.default;
        optVim = x: opt (vimStyle " ${x} ");
      in {
        vimcmd_symbol = optVim "NOR";
        vimcmd_replace_one_symbol = optVim "RE1";
        vimcmd_replace_symbol = optVim "REP";
        vimcmd_visual_symbol = optVim "VIS";
      };

      shlvl = {
        repeat = true;
        format = bold style.extraShellChars "$symbol";
        threshold = 0;
        repeat_offset = 2;
        symbol = "❯";
        disabled = false;
      };

      shell = {
        zsh_indicator = "z"; # ζ
        fish_indicator = "f"; # φ
        bash_indicator = "b"; # β
        nu_indicator = "n";
        format = style.shell "$indicator";
        disabled = false;
      };

      cmd_duration = {
        format = bold style.default "󱞩  took $duration ✦";
        show_notifications = true;
        min_time = 0;
        notification_timeout = 3500;
      };

      time = {
        format = style.neutral "$time";
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

      directory = let read_only = optSufSpace (style.attn "$read_only");
      in {
        format = read_only + (style.dir "$path");
        read_only = "🔒";
        truncation_symbol = "…/";
        truncate_to_repo = false;
        style = "";
      };

      git_branch = let
        git_sym = makeDelim rounded forwardSlash style.gitLabel "$symbol";
        branch = optPreSpace (style.gitLabel "$branch");
        remote = opt (style.git ":$remote_branch");
      in {
        format = git_sym + branch + remote;
        symbol = "󰘬";
        only_attached = false;
        style = "";
      };

      git_commit = let
        hash = (style.neutral "#$hash");
        tag = opt (style.neutral "$tag");
      in {
        format = opt (hash + tag);
        tag_symbol = "󰌕";
        only_detached = false;
        style = "";
        commit_hash_length = 4;
      };

      git_status = let
        defaultCount = "$count";
        _countSym = count: color: sym: color "${sym}${count}";
        countSym = _countSym defaultCount;
        aheadArrow = "🠙";
        behindArrow = "🠛";
        syncStatus =
          (makeDelim forwardSlash forwardSlash style.gitLabel ""); # 󰖟
        localStatus =
          (makeDelim forwardSlash forwardSlash style.gitLabel ""); # 󰋞󰊢
        ahead_behind = optPreSpace "${syncStatus} $ahead_behind";
        status = optPreSpace ("${localStatus}" + (concatStrMap optPreSpace ([
          "$conflicted"
          "$stashed"
          #"$deleted"
          #"$renamed"
          "$modified"
          "$staged"
          "$untracked"
          #"$typechanged"
        ])));
        symbols = {
          ahead = countSym style.ok aheadArrow; # 🟘
          behind = countSym style.alert behindArrow; # 🟗
          diverged = concatStrings [
            (style.info "$ahead_count ")
            (style.ok aheadArrow)
            (style.alert behindArrow)
            (style.info " $behind_count")
            # (_revCountSym "$ahead_count" style.ok aheadArrow)
            # (_revCountSym "$behind_count" style.alert behindArrow)
          ];
          up_to_date = style.ok ""; # 🙫󰓦󰄭
          conflicted = countSym style.alert ""; # ⮻⩙⪤⮺🗗 ⮼⧉❐❏⧉⮻⩙󰡌
          stashed = countSym style.info ""; # ⧈🞔
          deleted = countSym style.info ""; # ⊠⬚
          renamed = countSym style.info ""; # ⛋
          staged = countSym style.info ""; # ⭱▤▧▩⛶🞏
          #typechanged = countSym style.info "󱡔"; #◨󱎖
          modified = countSym style.alert "●"; # ⊡▩
          untracked = countSym style.alert ""; # ⌑⛶?
        };
      in {
        format = "(${ahead_behind})(${status})";
        style = "";
      } // symbols;

      git_state = let
        state_symbol = (makeDelim void void style.gitLabel "󰇘");
        state = preSpace (style.warning "$state");
        progress =
          opt (preSpace (style.warning "$progress_current/$progress_total"));
      in {
        format = opt (concatStrings [ state_symbol state progress ]);
        style = "";
      };

      git_metrics = {
        format = opt (concatStrSep preSpace [
          (style.ok "$+$added")
          (style.attn "-$deleted")
        ]);
      };

      nix_shell = let
        impure_msg = style.warning "⏣";
        pure_msg = style.warning "⬢";
        unknown_msg = style.alert "⌬";
      in {
        symbol = makeDelim rounded forwardSlash style.nixLabel "nix";
        format = style.nix "($symbol$state( ($name)))";
        inherit impure_msg pure_msg unknown_msg;
        style = "";
      };
    }; # // starship_config;
  };
}
