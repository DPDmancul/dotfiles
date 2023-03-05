# Theme

```nix modules/home/theme.nix
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    <<<modules/home/theme-imports>>>
  ];

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

## Window borders

Remove ugly borders from GTK apps

```nix "modules/home/theme" +=
xdg.configFile."gtk-4.0/gtk.css".text = ''
  window {
    padding: 0;
    box-shadow: none;
  }
'';
xdg.configFile."gtk-3.0/gtk.css".text = ''
  decoration {
    padding: 0;
  }
'';
```

## Window buttons

Hide window buttons

```nix "modules/home/theme" +=
dconf.settings."org/gnome/desktop/wm/preferences".button-layout = "";
xdg.configFile."gtk-3.0/settings.ini".text = ''
   gtk-decoration-layout=:menu
'';
```

## Background

Use random backgrounds with feh

```nix "flake-inputs" +=
feh-random-background = {
  url = github:KoviRobi/feh-random-background;
  flake = false;
};
wallpapers = {
  url = gitlab:DPDmancul/dotfiles-wallpapers;
  flake = false;
};
```

```nix "modules/home/theme-imports" +=
(inputs.feh-random-background + /home-manager-service.nix)
```

```nix "modules/home/theme" +=
services.feh-random-background = {
  enable = true;
  imageDirectory = "${inputs.wallpapers}";
  interval = "1m";
};
```

