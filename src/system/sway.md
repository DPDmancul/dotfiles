# Sway

Use Sway as window manager

```nix "config" +=
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = with pkgs; [
    <<<sway-packages>>>
  ];
};
```

```nix "env" +=
XDG_CURRENT_DESKTOP = "sway";
```

## Waybar

Use waybar instead of swaybar

```nix "sway-packages" +=
waybar
```

```nix "config" +=
programs.waybar.enable = true;
```

## Applications runner

```nix "sway-packages" +=
wofi
```

## Lockscreen

```nix "sway-packages" +=
swaylock
swayidle
```

## Clipboard

```nix "sway-packages" +=
wl-clipboard
```

## Notifications

```nix "sway-packages" +=
mako
```
## Screen

### Automatic randr

```nix "sway-packages" +=
autorandr
```

### Brightness

```nix "config" +=
programs.light.enable = true;
```

### Screen capturing

#### Screen sharing

```nix "config" +=
xdg.portal.wlr.enable = true;
```

## X compatibility

```nix "sway-packages" +=
xwayland
```

