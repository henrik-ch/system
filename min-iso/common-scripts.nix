{ stdenv, ... }:

stdenv.mkDerivation {
  name = "l-nix-install";
  src = ./common;
  installPhase = "install -Dm 755 -t $out/bin ./*";
}

