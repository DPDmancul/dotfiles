{ appimageTools, fetchurl }:
let
  pname = "musescore-appimage";
  version = "4.5.2";
  src = fetchurl {
    url = "https://cdn.jsdelivr.net/musescore/v${version}/MuseScore-Studio-${version}.251141401-x86_64.AppImage";
    hash = "sha256-0BC2Rkx4tNojB3608Jb5Sa5ousTICaiwCKDPv0jiYKU=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/share/applications/org.musescore.MuseScore4portable.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/org.musescore.MuseScore4portable.desktop \
      --replace-fail 'Exec=mscore4portable %U' 'Exec=${pname}'
    cp -r ${appimageContents}/share/icons $out/share
  '';
}

