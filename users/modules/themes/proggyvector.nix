{
  lib,
  stdenv,
  fetchurl,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "proggyvector";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "bluescan";
    repo = "proggyfonts";
    rev = "a9d7f1c75030295bb101fd49e0890fac8e797c8a";
    hash = "sha256-xtJAcfEBjuLrN3ELeTOPtGErp4imIrf9w1+UFO8Z+MI=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D -m 644 ProggyVector/*.ttf -t "$out/share/fonts/truetype"
    install -D -m 644 ProggyVector/*.otf -t "$out/share/fonts/opentype"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/bluescan/proggyfonts";
    description = "Set of fixed-width screen fonts that are designed for code listings";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [maintainers.myrl];
  };
}
