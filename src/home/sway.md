# Sway

```nix "home-config" +=
wayland.windowManager.sway = {
  enable = true;
  config = {
    <<<sway-config>>>
  };
};
```

## Modifier key

Use super as mod key

```nix "sway-config" +=
modifier = "Mod4";
```

## Keyboard layout

Use the European variant of the international keyboard

```nix "sway-config" +=
input."*".xkb_layout = "eu";
```

## Terminal

```nix "sway-config" +=
terminal = "kitty";
```

## Application launcher

```nix "sway-config" +=
menu = ''wofi --show=drun --line=5 --prompt=""'';
```

## Appearance

### Border and gaps

```nix "sway-config" +=
# TODO default_border pixel 2
gaps.inner = 5;
```

### Background

```nix "sway-config" +=
output."*".bg = "/run/current-system/sw/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png fill";
```




