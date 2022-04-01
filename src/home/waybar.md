# Waybar

Use waybar instead of swaybar

```nix "sway-config" +=
bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
```

```nix "home-config" +=
programs.waybar = {
  enable = true;
  # settings = [
  #   {
  #     modules = null;
  #     <<<waybar-bar-settings>>>
  #   }
  # ];
  # style = ''
  #     <<<waybar-bar-css>>>
  # '';
};
```

## Modules

```nix "waybar-bar-settings" +=
modules-left = [
  "sway/workspaces"
  "sway/mode"
  "custom/media"
];
```

```nix "waybar-bar-settings" +=
modules-center = [
  "sway/window"
];
```

```nix "waybar-bar-settings" +=
modules-right = [
  # "mpd"
  "idle_inhibitor"
  "pulseaudio"
  "network"
  "cpu"
  "memory"
  "temperature"
  "backlight"
  # "keyboard-state"
  # "sway/language"
  "battery"
  "battery#bat2"
  "clock"
  "tray"
];
```

## Style

```nix "waybar-bar-settings" +=
height = 20;
spacing = 4;
```

```css "waybar-bar-css" +=
* {
  font-size: 12px;
}
```
