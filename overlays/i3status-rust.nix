self: super:
super.i3status-rust.overrideAttrs (old: rec {
  version = 0.30.3;
  src = self.lib.fetchFromGithub {
    owner = "greshake";
    repo = old.pname;
    rev = "refs/tags/v${version}";
  };
})
