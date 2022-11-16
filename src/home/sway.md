# Sway

```nix "home-config" +=
wayland.windowManager.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
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

```nix "PereBook/system" +=
environment.sessionVariables.XDG_CURRENT_DESKTOP = "sway";
```

## Auto startup

```nix "home-config" +=
programs.fish.loginShellInit = lib.mkBefore ''
  if test (tty) = /dev/tty1
    exec sway &> /dev/null
  end
'';
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

Enable Num Lock at startup

```nix "sway-config" +=
input."*".xkb_numlock = "enabled";
```

## Terminal

```nix "sway-config" +=
terminal = "kitty";
```

## Application launcher

```nix "home-packages" +=
wofi
```

```nix "sway-config" +=
menu = ''wofi --show=drun -i --prompt=""'';
```

```nix "home-config" +=
xdg.configFile."wofi/config".text = ''
  allow_images=true # Enable icons
  insensitive=true  # Case insensitive search
'';
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
"--locked XF86AudioRaiseVolume" = "exec pamixer -u -i 5";
"--locked XF86AudioLowerVolume" = "exec pamixer -d 5";
"--locked XF86AudioMute" = "exec pamixer -t";
```

## Screen

### Brightness

Don't know why the following are triggered twice, so a step of 2 is indeed a step of 4.

```nix "sway-keybind" +=
"--locked XF86MonBrightnessDown" = "exec light -U 2";
"--locked XF86MonBrightnessUp" = "exec light -A 2";
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

```nix "home-packages" +=
swaylock-effects
```

Grant PAM access to swaylock

```nix "config" +=
security.pam.services.swaylock = {
  text = "auth include login";
};
```

```nix "sway-keybind" +=
"Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
```

### Idle

```nix "home-config" +=
services.swayidle = {
  enable = true;
  timeouts = [{
    timeout = 300;
    command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
    resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
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
"${modifier}+x" = "exec nemo";
"${modifier}+v" = "exec kitty nvim";
```

## Clipboard

```nix "home-packages" +=
wl-clipboard
wl-clipboard-x11
copyq
```

Start clipboard manager

```sh "sway-extra-config" +=
exec ${pkgs.copyq}/bin/copyq
```

Clipboard history picker

```nix "sway-keybind" +=
"${modifier}+q" = "exec copyq toggle";
```

## Floating windows

Enable floating by default for some applications

```nix "sway-config" +=
floating.criteria = [
  { app_id = "firefox"; title = "^Firefox [-—] Sharing Indicator$"; }
  { app_id = "firefox"; title = "^Picture-in-Picture$"; }
  { app_id = "firefox"; title = "^Developer Tools [-—]"; }
  { app_id = "file-roller"; title = "Extract"; }
  { app_id = "file-roller"; title = "Compress"; }
  { app_id = "nemo"; title = "Properties"; }
  { app_id = "pavucontrol"; }
  { app_id = "qalculate-gtk"; }
  { app_id = "copyq"; }
];
```

## Polkit

```nix "home-packages" +=
polkit_gnome
```

