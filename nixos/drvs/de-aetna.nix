{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "de-aetna";
  version = "1.000";

  src = fetchzip {
    url = "https://www.designingtyperevivals.com/DeAetna_font.zip";
    stripRoot = false;
    hash = "sha256-LwnjOL8zWswvJ/JjDngauv8Q5NIDBk+BFYVQw0GojN4=";
  };

  installPhase = ''
    runHook preInstall

    install -D DeAetna_font/DeAetna_license.txt -t $out/share/doc/${pname}
    install -D DeAetna_font/DeAetna_V${version}/* -t $out/share/fonts/opentype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.designingtyperevivals.com/";
    description = "A font revival of the roman cut by by Francesco Griffo for the De Aetna (1496)";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [];
  };
}
