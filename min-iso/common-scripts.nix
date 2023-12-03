{ stdenv, ... }:

stdenv.mkDerivation {
  name = "common-scripts";
  src = ./common;
  installPhase = "install -Dm 755 -t $out/bin ./*";
}

