# Sway

Use Sway as window manager

```nix "config" +=
programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = with pkgs; [
    <<<sway_packages>>>
  ];
};
```

```nix "env" +=
XDG_CURRENT_DESKTOP = "sway";
```

## Waybar

Use waybar instead of swaybar

```nix "config" +=
programs.waybar.enable = true;
```

## Applications runner

```nix "sway_packages" +=
wofi
```

## Lockscreen

```nix "sway_packages" +=
swaylock
swayidle
```

## Clipboard

```nix "sway_packages" +=
wl-clipboard
```

## Notifications

```nix "sway_packages" +=
mako
```
## Screen

### Automatic randr

```nix "sway_packages" +=
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

```nix "sway_packages" +=
xwayland
```

