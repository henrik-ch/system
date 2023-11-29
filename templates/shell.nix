let
  sources = import ./npins;
  pkgs = import source.nixpkgs {}; 
in
pkgs.mkShell {
  packages = with pkgs; [
    # ...
  ];
}
