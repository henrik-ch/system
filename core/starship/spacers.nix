inputs:
with (import ./fmt.nix inputs);
with (import ./useful.nix inputs);
with (import ./lib_imports.nix inputs);
rec {
  repeatSym = sym: n: concatStrings (replicate n sym);

  _spacer = sym: {
    inherit sym;
    __functor = __intoStyledSpacer;
  };
  __intoStyledSpacer = spacer: stylor:
    spacer // { inherit stylor; __functor = __intoSpace; };
  __intoSpace = { stylor, sym }: n: stylor (repeatSym sym n);

  _gap = _spacer " ";
  gap = _gap defaultStylor;

  _block = stylor: _spacer " " (swapStylorColors stylor);
  block = _block defaultStylor;

  _bar = _spacer "―";
  bar = _bar defaultStylor;

  noSpace = _spacer "" emptyStylor;
}
