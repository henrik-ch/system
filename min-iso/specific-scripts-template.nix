{ stdenv, ... }:

stdenv.mkDerivation {
  name = "specific-scripts";
  src = ./MISSING;
  installPhase = "install -Dm 755 -t $out/bin ./MISSING/*";
}
