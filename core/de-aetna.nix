{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "de-aetna";
  version = "1.000";

  src = fetchzip {
    url = "https://www.designingtyperevivals.com/DeAetna_font.zip";
    stripRoot = false;
    hash = "";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/{doc/${pname}-${version},fonts/{opentype}}
    cp -v DeAetna_license.txt $out/share/doc/${pname}-${version}/
    cp -v DeAetna_V${version}/*.otf $out/share/fonts/opentype

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
