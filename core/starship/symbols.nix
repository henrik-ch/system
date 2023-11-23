inputs:
with (import ./fmt.nix inputs);
with (import ./useful.nix inputs);
with (import ./lib_imports.nix inputs);
with (import ./spacers.nix inputs);
rec {
  __sym = stylor_funct: sym: {
    inherit sym;
    inherit stylor_funct;
    __functor = __intoStyledSymFunctor;
  };
  id = x: x;
  _sym = __sym id;

  __intoStyledSymFunctor = sym: f: stylor:
    __intoStyledSym sym (f stylor);
  __intoStyledSym = sym: stylor: (stylor sym);

  noSym = __sym id "" emptyStylor;

  __symPair = l: r: with builtins; {
    inherit l; inherit r;
    __functor = self: stylor:
      if hasAttr "l" stylor then
        {
          l = self.l stylor.l;
          r = self.r stylor.r;
        }
      else
        {
          l = self.l stylor;
          r = self.r stylor;
        };
  };

  _symPair = f: raw_l: raw_r: {
    l = __sym f raw_l;
    r = __sym f raw_r;
  };

  _smoothPair = _symPair id "" "";
  _sharpPair = _symPair swapStylorColors "" "";

  smoothPair = _smoothPair defaultStylor;
  sharpPair = _sharpPair defaultStylor;
}
