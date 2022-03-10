# Sway

```nix "home-config" +=
wayland.windowManager.sway = {
  enable = true;
  config = rec {
    <<<sway-config>>>
    keybindings = lib.mkOptionDefault {
      <<<sway-keybind>>>
    };
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
menu = ''wofi --show=drun -i --prompt=""'';
```

### Poweroff

```nix "sway-keybind" +=
"${modifier}+Shift+e" = ''
  exec sh -c ' \
    case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | wofi --dmenu -i --prompt="Logout menu") in \
      "Shutdown") systemctl poweroff;; \
      "Suspend") systemctl suspend;; \
      "Reboot") systemctl reboot;; \
      "Logout") swaymsg exit;; \
    esac \
  '
'';
```

## Notifications

```nix "home-config" +=
programs.mako = {
  enable = true;
};
```

## Volume

```nix "sway-keybind" +=
"--locked XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
"--locked XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
"--locked XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
```

## Screen

### Brightness

```nix "sway-keybind" +=
"--locked XF86MonBrightnessDown" = "exec light -U 30";
"--locked XF86MonBrightnessUp" = "exec light -A 30";
```

#### Red light

```nix "home-config" +=
services.wlsunset = {
  enable = true;
  latitude = "46"; # North
  longitude = "13"; # East
};
```

### Autorandr

```nix "home-config" +=
services.kanshi = {
  enable = true;
};
```

### Lock

```nix "sway-keybind" +=
"Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
```

### Idle

TODO

```nix "home-config-TODO" +=
services.swayidle = {
  enable = true;
  timeouts = [{
    timeout = 300;
    command = ''swaymsg "output * dpms off"'';
    resumeCommand = ''swaymsg "output * dpms on"'';
  }];
};
```

### Capture

Use grimshot to take screenshots

```nix "home-packages" +=
sway-contrib.grimshot
```

Save (_print_) to file

```nix "sway-keybind" +=
"${modifier}+p" = "exec grimshot save active";       # Active window
"${modifier}+Shift+p" = "exec grimshot save area";   # Select area
"${modifier}+Mod1+p" = "exec grimshot save output";  # Whole screen
"${modifier}+Ctrl+p" = "exec grimshot save window";  # Choose window
```

Copy (_yank_) to clipboard

```nix "sway-keybind" +=
"${modifier}+y" = "exec grimshot copy active";       # Active window
"${modifier}+Shift+y" = "exec grimshot copy area";   # Select area
"${modifier}+Mod1+y" = "exec grimshot copy output";  # Whole screen
"${modifier}+Ctrl+y" = "exec grimshot copy window";  # Choose window
```

## Shortcuts

```nix "sway-keybind" +=
"${modifier}+z" = "exec firefox";
"${modifier}+x" = "exec pcmanfm";
```

## Import environment variables

```nix "sway-extraconfig"
exec dbus-update-activation-environment --systemd DISPLAY \
  WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP \
  QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE
```



