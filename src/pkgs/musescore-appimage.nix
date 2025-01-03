{ appimageTools, fetchurl }:
let
  pname = "musescore-appimage";
  version = "4.4.4";
  src = fetchurl {
    url = "https://cdn.jsdelivr.net/musescore/v${version}/MuseScore-Studio-${version}.243461245-x86_64.AppImage";
    hash = "sha256-g5mb9mPqh5lDV2wIBugzFMKtjJzGuXm5mIZVvsyRBh4=";
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

