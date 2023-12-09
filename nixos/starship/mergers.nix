{ lib, isTerminal, isIdentity }:
let
  isMerger = x: builtins.isAttrs x && builtins.hasAttr "get" x;
  hasMergeOp = builtins.hasAttr "mergeOp";
  matchingMergers = xs:
    builtins.all (x: isMerger x) xs && builtins.all (x: isTerminal x.item) xs;
  matchingTerminals = builtins.all isTerminal;

  applyMerge = self: next:
    if isTerminal next && matchingTerminals [ self.item next ] then
      if isIdentity next then self.item else self.mergeOp self.item next
    else if matchingMergers [ self next ] then
      if hasMergeOp next then
        merge next.mergeOp (self.mergeOp self.item next.item)
      else
        merge self.mergeOp (self.mergeOp self.item next.item)
    else
      abort "${lib.debug.traceVal next} is not mergeable with ${
        lib.debug.traceVal self
      }";

  merge = { mergeOp, item }: {
    inherit mergeOp item;
    __functor = applyMerge;
  };
in {
  inherit isMerger hasMergeOp matchingMergers matchingTerminals isIdentity
    applyMerge;
}
