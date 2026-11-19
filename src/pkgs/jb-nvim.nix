{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "jb-nvim";
  version = "0-unstable-2026-11-06";
  src = fetchFromGitHub {
    owner = "nickkadutskyi";
    repo = "jb.nvim";
    rev = "27c1fb3204463bdb02497152926a820e8ad2bb0b";
    hash = "sha256-EgLomrQ3Icqa+90XJER/ZjdEz5avWKoyxcZBSbbFL08=";
  };
  doCheck = false;
}
