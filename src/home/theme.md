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

```nix "home-let" +=
wpaperd = with pkgs; rustPlatform.buildRustPackage rec {
  pname = "wpaperd";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "danyspin97";
    repo = pname;
    rev = "89f32c907386af58587df46c10784ab4f17ed31e";
    sha256 = "sha256-n1zlC2afog0UazsJEBAzXpnhVDeP3xqpNGXlJ65umHQ=";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    libxkbcommon
  ];

  cargoSha256 = "sha256-xIXmvMiOpgZgvA9C8tyzoW5ZA1rQ0e+/RuWdzJkoBsc=";
};
```

```nix "home-packages" +=
wpaperd
```

```nix "home-config" +=
xdg.configFile."wpaperd/output.conf".text = ''
  [default]
  path = "/home/dpd-/Pictures/Wallpapers/"
  duration = "1m"
'';
```

```sh "sway-extra-config" +=
exec ${wpaperd}/bin/wpaperd
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
home.pointerCursor = {
  name = "Bibata-Modern-Classic";
  package = pkgs.bibata-cursors;
  size = 24;
};
```
