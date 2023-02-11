# Theme

```nix modules/home/theme.nix
{ config, pkgs, lib, ... }:
{
  <<<modules/home/theme>>>
}
```

## Qt as GTK

Use GTK theme in Qt apps

```nix "modules/home/theme" +=
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

```nix "modules/home/theme" +=
gtk.enable = true;
gtk.iconTheme = {
  name = "Tela";
  package = pkgs.tela-icon-theme;
};
```

Use the same icons in Qt apps

```nix "modules/home/theme" +=
dconf.settings."org/gnome/desktop/interface" = {
  icon-theme = config.gtk.iconTheme.name;
};
```

## Cursors

```nix "modules/home/theme" +=
home.pointerCursor = {
  name = "Bibata-Modern-Classic";
  package = pkgs.bibata-cursors;
  size = 24;
  gtk.enable = true;
};
```
