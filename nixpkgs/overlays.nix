# https://nixos.org/manual/nixpkgs/stable/#sec-overlays-definition
[
  (
    let
      sources = ./npins/source.json;
    in
    self: _super: {
      inherit (sources) nixpkgs;
    }
  )
]
