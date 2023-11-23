inputs:
with import ./lib_imports.nix inputs;
with builtins;
{
  ifThenElse = p: x: y: if p then x else y;
  ifNotEmptyThen = f: s: optionalString (isStrNonEmpty s) (f s);
  prefixIfNonEmpty = pre: ifNotEmptyThen (s: "${pre}${s}");
  isStrNonEmpty = s: (stringLength s) > 0;
  intoNewFunctor = existing_attrs: new_attrs: __functor:
    existing_attrs // new_attrs // {
    inherit __functor;
  };
  capitalize =
    s:
      let
        head = (toUpper (substring 0 1 s));
        tail = (substring 1 (stringLength s) s);
      in
        "${head}${tail}";
}