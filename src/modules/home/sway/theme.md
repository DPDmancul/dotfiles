# Theme

## Border and gaps

```nix "modules/home/sway-config" +=
gaps.inner = 5;
```

Disable border for inactive windows and for alone ones

```nix "modules/home/sway-config" +=
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

```nix "modules/home/sway-packages" +=
unstable.wpaperd
```

```nix "modules/home/sway" +=
xdg.configFile."wpaperd/output.conf".text = ''
  [default]
  path = "${inputs.wallpapers}"
  duration = "1m"
'';
```

```sh "modules/home/sway-extra-config" +=
exec ${pkgs.unstable.wpaperd}/bin/wpaperd
```

## Qt as GTK

Use GTK theme in Qt apps

```nix "modules/home/sway" +=
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

```nix "modules/home/sway" +=
gtk.enable = true;
gtk.iconTheme = {
  name = "Tela";
  package = pkgs.tela-icon-theme;
};
```

Use the same icons in Qt apps

```nix "modules/home/sway" +=
dconf.settings."org/gnome/desktop/interface" = {
  icon-theme = config.gtk.iconTheme.name;
};
```

## Cursors

```nix "modules/home/sway" +=
home.pointerCursor = {
  name = "Bibata-Modern-Classic";
  package = pkgs.bibata-cursors;
  size = 24;
  gtk.enable = true;
};
```
