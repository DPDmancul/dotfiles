# Sway

```nix "home-config" +=
wayland.windowManager.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  config = rec {
    <<<sway-config>>>
    keybindings = lib.mkOptionDefault
      (with config.wayland.windowManager.sway.config; {
        <<<sway-keybind>>>
      } // builtins.listToAttrs (builtins.concatMap
        ({ name, value }:
          let
            ws = builtins.toString value;
          in
          [
            { name = "${modifier}+${name}"; value = "workspace number ${ws}"; }
            { name = "${modifier}+Shift+${name}"; value = "move container to workspace number ${ws}"; }
            { name = "${modifier}+Ctrl+${name}"; value = "move container to workspace number ${ws}, workspace number ${ws}"; }
          ])
        ([
          { name = "grave"; value = 0; }
          { name = "Escape"; value = 10; }
        ] ++ (map
          (n: { name = builtins.toString n; value = n; })
          [ 1 2 3 4 5 6 7 8 9 ])
        ++ map
          (n: { name = "F${builtins.toString n}"; value = 10 + n; })
          [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
        )
      ));
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

### Move to another screen

```nix "sway-keybind" +=
"${modifier}+Ctrl+Shift+${left}" = "move workspace to output left";
"${modifier}+Ctrl+Shift+${down}" = "move workspace to output down";
"${modifier}+Ctrl+Shift+${up}" = "move workspace to output up";
"${modifier}+Ctrl+Shift+${right}" = "move workspace to output right";
"${modifier}+Ctrl+Shift+Left" = "move workspace to output left";
"${modifier}+Ctrl+Shift+Down" = "move workspace to output down";
"${modifier}+Ctrl+Shift+Up" = "move workspace to output up";
"${modifier}+Ctrl+Shift+Right" = "move workspace to output right";
```

### Lock

```nix "home-packages" +=
swaylock-effects
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
  { app_id = "firefox"; title = "^Developer Tools [-—]"; }
  { app_id = "file-roller"; title = "Extract"; }
  { app_id = "file-roller"; title = "Compress"; }
  { app_id = "nemo"; title = "Properties"; }
  { app_id = "pavucontrol"; }
  { app_id = "qalculate-gtk"; }
  { app_id = "copyq"; }
];
window.commands = [
  { criteria = { app_id = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
  { criteria = { app_id = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
  { criteria = { shell = "xwayland"; }; command = ''title_format "%title [%shell]"''; } # TODO: does not work for waybar
];
```

## Polkit

```nix "home-packages" +=
polkit_gnome
```

