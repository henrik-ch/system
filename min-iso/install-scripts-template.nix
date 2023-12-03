{ stdenv, ... }:

stdenv.mkDerivation {
  name = "MISSING-nix-install";
  src = ./.;
  installPhase = "install -Dm 755 -t $out/bin ./MISSING/*";
}
