# Theme

## Border and gaps

```nix "sway-config" +=
gaps.inner = 5;
```

Disable border for inactive windows and for alone ones

```nix "sway-config" +=
colors.unfocused = let transparent = "#00000000"; in {
  background = "#222222";
  border = transparent;
  childBorder = transparent;
  indicator = "#292d2e";
  text = "#888888";
};
gaps.smartBorders = "on";
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

## Qt as GTK

Use GTK theme in Qt apps

```nix "home-config" +=
qt = {
  enable = true;
  platformTheme = "gnome";
  style = {
    name = "adwaita";
    package = pkgs.adwaita-qt;
  };
};
```

## Icons

```nix "home-config" +=
gtk.enable = true;
gtk.iconTheme = {
  name = "Tela";
  package = pkgs.tela-icon-theme;
};
```

Use the same icons in Qt apps

```nix "home-config" +=
dconf.settings."org/gnome/desktop/interface" = {
  icon-theme = config.gtk.iconTheme.name;
};
```

## Cursors

```nix "home-config" +=
xsession.pointerCursor = {
  name = "Bibata-Modern-Classic";
  package = pkgs.bibata-cursors;
  size = 24;
};
```
