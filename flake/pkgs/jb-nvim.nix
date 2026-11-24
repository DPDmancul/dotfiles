{ vimUtils, fetchFromGitHub }:

vimUtils.buildVimPlugin {
  pname = "jb-nvim";
  version = "0-unstable-2026-11-24";
  src = fetchFromGitHub {
    owner = "nickkadutskyi";
    repo = "jb.nvim";
    rev = "5fa87f58164030687f8e58d5616357297803a3c8";
    hash = "sha256-xL3uyx/0Usf82oN7e4CsNZTahpR0v3InhbLrLdaQ3zI=";
  };
  doCheck = false;
}
