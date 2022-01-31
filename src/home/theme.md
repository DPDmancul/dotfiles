# Theme

## Border and gaps

```nix "sway-config" +=
gaps.inner = 5;
```

## Background

Use wpaperd for random backgrounds

```nix "home-packages" +=
(rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "DPDmancul";
    repo = "wpaperd-no-nightly";
    rev = "81a17ea424c96b1e6b2eba2a12e0396c5b7f7eda";
    sha256 = "DUMuCWwSECoONeaCCi7u1ubzngFjOpo9gnPLvc00zh0=";
  };

  cargoSha256 = "SssN6cFSRDKt6MSyeeOwv31zXQHRdGVbjHf5Bd5d4l4=";
})
```

```nix "home-config" +=
xdg.configFile."wpaperd/output.conf".text = ''
  [default]
  path = "/home/dpd-/Pictures/Wallpapers/"
  duration = "1m"
'';
```

TODO: wpaperd cannot find libwayland

```sh "sway-extra-config" +=
# exec {pkgs.wpaperd}/bin/wpaperd
```

Temporary "fix"

```nix "sway-config" +=
output."*".bg = ''`find ~/Pictures/Wallpapers/ -type f | shuf -n 1` fill'';
```

## Icons

```nix "home-config" +=
gtk.enable = true;
gtk.iconTheme = {
  name = "Tela";
  package = pkgs.tela-icon-theme;
};
```

## Cursors

```nix "home-config" +=
xsession.pointerCursor = {
  name = "Bibata-Modern-Classic";
  package = pkgs.bibata-cursors;
};
```
