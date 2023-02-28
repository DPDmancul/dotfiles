# Gnome

```nix modules/home/gnome/default.nix
{ config, pkgs, lib, ... }:
{
  dconf.settings = {
    <<<modules/home/gnome-dconf>>>
  };

  home.packages = with pkgs; [
    unstable.gnomeExtensions.forge
    gnomeExtensions.blur-my-shell
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.pop-shell
    xclip # TODO move
  ];
}
```

Focus on hover

```nix "modules/home/gnome-dconf" +=
"org/gnome/desktop/wm/preferences".focus-mode = "mouse";
```

**TODO** European keyboard, firefox extension

Enable night light

```nix "modules/home/gnome-dconf" +=
"org/gnome/settings-daemon/plugins/color".night-light-enabled = true;

# TODO organize
"org/gnome/desktop/screensaver".lock-enabled = false; # Do not lock after screen off
"org/gnome/desktop/wm/preferences".resize-with-right-button = true;
"org/gnome/mutter".dynamic-workspaces = true;
```

Eurkey

```nix "modules/home/gnome-dconf" +=
"org/gnome/desktop/input-sources".sources = [(lib.hm.gvariant.mkTuple ["xkb" "eu"])];
```

## Extensions

```nix "modules/home/gnome-dconf" +=
"org/gnome/shell" = {
  disable-user-extensions = false;
  enabled-extensions = [
    # "forge@jmmaranan.com"
    "pop-shell@system76.com"
    "blur-my-shell@aunetx"
    "rounded-window-corners@yilozt"
    "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
  ];
};
```

**TODO**
- Blur my Shell
- Rounded corners

## Theme

Hide title bar

```nix "modules/home/gnome-dconf" +=
"org/gnome/terminal/legacy/settings".headerbar = false; # TODO
```

**TODO** import from sway settings cursors, icons and background


```css
.ssd headerbar * {
  margin-top: -100px;
}
.ssd headerbar.titlebar,
.ssd headerbar.titlebar button.titlebutton {
  border: none;
  font-size: 0;
  min-height: 0;
  padding: 0;
}
```
