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
  version = "1.0.0-rc.2";

  src = fetchFromGitLab {
    owner = "DPDmancul";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-OL9NxMlC3KkYpfuquf/fF6B/KB8K8wtQm3wdoNIcz/I=";
  };

  cargoHash = "sha256-kJmsm6B7UNSv8sWdtnHpnrrmRYzVDYfFwD7ZD22v5rY=";

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
