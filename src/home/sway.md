# Sway

```nix "home-config" +=
wayland.windowManager.sway = {
  enable = true;
  config = {
    <<<sway-config>>>
  };
  extraConfig = ''
    <<<sway-extra-config>>>
  '';
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
menu = ''wofi --show=drun --prompt=""'';
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

## Fix dbus

Dbus cannot find sway and so GTK+ takes 20 seconds to start

See
- <https://github.com/swaywm/sway/wiki#gtk-applications-take-20-seconds-to-start>
- <https://github.com/nix-community/home-manager/pull/2385>

Disable automatic systemd integration:

```nix "home-config" +=
wayland.windowManager.sway.systemdIntegration = false;
```

Manual enabling systemd integration:

```sh "sway-extra-config" +=
exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK && \
     hash dbus-update-activation-environment 2>/dev/null && \
     dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK && \
     systemctl --user start sway-session.target
```

```nix "home-config" +=
systemd.user.targets.sway-session = {
  Unit = {
    Description = "sway compositor session";
    Documentation = [ "man:systemd.special(7)" ];
    BindsTo = [ "graphical-session.target" ];
    Wants = [ "graphical-session-pre.target" ];
    After = [ "graphical-session-pre.target" ];
  };
};
```


