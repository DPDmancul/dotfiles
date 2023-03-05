# Picom (compositor)

Enable transparency for Firefox (and Polybar) with picom compositor.

I don't use blur since it slows the system too much and becomes unusable.


```nix modules/home/i3/picom.nix
{ config, pkgs, lib, ... }:
{
  services.picom = {
    enable = true;
    <<<modules/home/i3/picom-settings>>>
  };
}
```

Use glx backend since xrender shows black background on non-transparent windows

```nix "modules/home/i3/picom-settings" +=
backend = "glx";
```

Enable `xrender-sync-fence` to overcome some flickering

```nix "modules/home/i3/picom-settings" +=
settings = {
  xrender-sync-fence = true;
  vsync = true;
};
```

## Rounded corners

```nix "modules/home/i3/picom-settings" +=
settings = {
  corner-radius = 10;
  round-borders = 1;
};
```

## Shadow

```nix "modules/home/i3/picom-settings" +=
shadow = true;
```

Disable for some windows

```nix "modules/home/i3/picom-settings" +=
shadowExclude = [
  # i3 tabs
  "class_g = 'i3-frame'"
  # Firefox extension menus
  "class_g = 'firefox' && argb"
  # Telegram context menu
  "_NET_WM_WINDOW_TYPE:a *= '_KDE_NET_WM_WINDOW_TYPE_OVERRIDE'"
];
wintypes = lib.concatMapToAttrs (type: {
  ${type} = {
    shadow = false;
  };
}) [
  "dock"
  "desktop"
  "menu"
  "dropdown_menu"
  "popup_menu"
  "tooltip"
  "i3-frame"
];
```

## Fixes

Do not show other windows under (transparent) focused one in tabbed view

```nix "modules/home/i3/picom-settings" +=
opacityRules = [
  "0:_NET_WM_STATE@[0]:32a *= '_NET_WM_STATE_HIDDEN'"
  "0:_NET_WM_STATE@[1]:32a *= '_NET_WM_STATE_HIDDEN'"
  "0:_NET_WM_STATE@[2]:32a *= '_NET_WM_STATE_HIDDEN'"
  "0:_NET_WM_STATE@[3]:32a *= '_NET_WM_STATE_HIDDEN'"
  "0:_NET_WM_STATE@[4]:32a *= '_NET_WM_STATE_HIDDEN'"
];
```

