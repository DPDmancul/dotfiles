{ pkgs, rustPlatform, fetchFromGitHub, ... }:
with pkgs; rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = pname;
    rev = "89f32c907386af58587df46c10784ab4f17ed31e";
    sha256 = "n1zlC2afog0UazsJEBAzXpnhVDeP3xqpNGXlJ65umHQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
  ];

  cargoSha256 = "xIXmvMiOpgZgvA9C8tyzoW5ZA1rQ0e+/RuWdzJkoBsc=";
}
