inputs:
with (import ./fmt.nix inputs);
with (import ./useful.nix inputs);
with (import ./lib_imports.nix inputs);
with (import ./spacers.nix inputs);
with (import ./symbols.nix inputs);
with (import ./colors.nix inputs);
with builtins;
rec {
  _capsule = stops: out_space: in_space: {
    inherit stops out_space in_space;
    __functor = __intoStylorCapsule;
  };
  __intoStylorCapsule = capsule: content_stylor:
    capsule // {
      inherit content_stylor;
      __functor = __fmtCapsule;
    };
  __fmtCapsule =
    { stops, out_space, in_space, content_stylor, ... }:
      content:
        concatStrings
          [ out_space stops.l in_space
            (content_stylor content)
            in_space stops.r
          ];
  _smoothCap = _capsule _smoothPair _gap _noSpace;
  _sharpCap = _capsule _sharpPair _bar _noSpace;
  _smoothSharpCap = _capsule (__symPair _smoothPair.l _sharpPair.r) _gap _noSpace;
  _sharpSmoothCap = _capsule (__symPair _sharpPair.l _smoothPair.r) _gap _noSpace;

  _applyStylorsSpacing =
  cap@{ stop, out_space, in_space, ...}:
  out_width: in_width: cap_element_stylor: (
    cap // {
      stops = stops cap_element_stylor;
      out_space = out_space cap_element_stylor;
      in_space = in_space cap_element_stylor;
    }
  );

  _smoothTightCap = _applyStylorsSpacing _smoothCap 0 0;
  _smoothGapCap = _applyStylorsSpacing _smoothCap 1 0 ;
  _sharpCapTight = _applyStylorsSpacing _smoothCap 0 0;
}