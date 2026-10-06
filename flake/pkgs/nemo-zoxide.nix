 {
  stdenv,
  lib,
  fetchFromGitLab,
  pkg-config,
  glib,
  gtk3,
  nemo,
  rustPlatform,
  zoxide,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nemo-zoxide";
  version = "1.0.0-rc.1";

  src = fetchFromGitLab {
    owner = "DPDmancul";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-GSMHUIrRWYre5PbKWz0IT4H3CF8kzdWsda+NwJpFxMw=";
  };

  cargoHash = "sha256-XQTuZQHPNzLP+SsnoS1Fy611vhetfKA2P9xbeON3Q5w=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    gtk3
    nemo
  ];

  installPhase = ''
    install -Dm755 \
      target/${stdenv.hostPlatform.rust.rustcTarget}/release/libnemo_zoxide.so \
      "$out/${nemo.extensiondir}/libnemo_zoxide.so"
  '';

  env.ZOXIDE_CMD = lib.getExe zoxide;
  env.PKG_CONFIG_LIBNEMO_EXTENSION_EXTENSIONDIR = "${placeholder "out"}/${nemo.extensiondir}";

  meta = {
    homepage = "https://gitlab.com/DPDmancul/nemo-zoxide/";
    description = "Nemo zoxide extension";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      DPDmancul
    ];
  };
})
