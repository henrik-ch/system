inputs:
with import ./lib_imports.nix inputs;
with import ./useful.nix inputs;
rec {
  fgFmt = fg: prefixIfNonEmpty "fg:" fg;
  bgFmt = bg: prefixIfNonEmpty " bg:" bg;
  emphasesFmt = emphases: prefixIfNonEmpty " " emphases;
  styleFmt = { fg, bg, emphases, ... }:
    ifNotEmptyThen (s: "(${s})")
      "${fgFmt fg}${bgFmt bg}${emphasesFmt emphases}";

  fmt = txt: stylor:
    ifNotEmptyThen (s: "[${txt}]${styleFmt stylor}")
      txt;

  _createStylor = fg: bg: {
    inherit fg bg;
    emphases = "";
    __swap = self: self // {
      fg = self.bg;
      bg = self.fg;
    };
    __functor = __intoStylizedGroup;
  };
  swapStylorColors = stylor: stylor.__swap stylor;
  __intoStylizedGroup = stylor: txt: "${txtFmt txt}${styleFmt fg bg emphases}";

  defaultStylor = _createStylor "slate" "black";
  emptyStylor = _createStylor "" "";
  no_op = fmt "" emptyStylor;

  emphasize = stylor@{ emphases, ... }: emphasis:
    let
      emphases = "${emphases}${prefixIfNonEmpty " " emphasis}";
    in
      stylor // { inherit emphases; };
}
