{ rustPlatform, fetchFromGitHub, pkg-config, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = pname;
    rev = version;
    sha256 = "n1zlC2afog0UazsJEBAzXpnhVDeP3xqpNGXlJ65umHQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
  ];

  cargoSha256 = "8ZMdbJvedDqoDr2rhKM1TMB5N4aRde04x/9H212fe68=";
}
