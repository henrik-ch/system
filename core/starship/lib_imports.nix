{ lib, ... }:
{
  # picked from:
  # https://nixos.org/manual/nixpkgs/stable/#sec-functions-library-strings
  concatStrings = lib.strings.concatStrings;
  optionalString = lib.strings.optionalString;
  toUpper = lib.strings.toUpper;

  replicate = lib.lists.replicate;

  mapAttrs = lib.attrsets.mapAttrs;
  concatMapAttrs = lib.attrsets.concatMapAttrs;
}
