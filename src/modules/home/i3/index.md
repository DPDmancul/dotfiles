# i3

```nix modules/home/i3/default.nix
{ config, pkgs, lib, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;
  alt = "Mod1";
in
{
  imports = [
    ./keybinds.nix
    ./picom.nix
    ./polybar.nix
  ];

  xsession = {
    enable = true; # .xsession for lightDM
    windowManager.i3 = {
      enable = true;
      config = {
        <<<modules/home/i3-config>>>
        startup = [
          <<<modules/home/i3-startup>>>
        ];
      };
    };
  };

  <<<modules/home/i3>>>

  home.packages = with pkgs; [
    <<<modules/home/i3-packages>>>
  ];
}
```

## Modifier key

Use super as mod key

```nix "modules/home/i3-config" +=
modifier = "Mod4";
```

## Terminal

```nix "modules/home/i3-config" +=
terminal = "kitty";
```

## Application launcher

```nix "modules/home/i3" +=
programs.rofi = {
  enable = true;
  terminal = config.xsession.windowManager.i3.config.terminal;
  extraConfig = {
    show-icons = true;
  };
  theme = with config.lib.formats.rasi; {
    "@import" = "gruvbox-light";
    window.border = mkLiteral "none";
  };
};
```

```nix "modules/home/i3-config" +=
menu = "rofi -show drun";
```

## Notifications

```nix "modules/home/i3" +=
services.dunst = {
  enable = true;
  iconTheme = {
    inherit (config.gtk.iconTheme) name package;
  };
  settings = {
    global = {
      follow = "mouse";
      corner_radius = config.services.picom.settings.corner-radius;
    };
  };
};
```

## Screen

### Red light

```nix "modules/home/i3" +=
services.gammastep = {
  enable = true;
  latitude = 46.; # North
  longitude = 13.; # East
  tray = false;
};
```

### Lock

```nix "modules/home/i3-packages" +=
i3lock-color
```

```nix "modules/home/i3" +=
i3AddKeybinds."Ctrl+${alt}+l" = ''exec --no-startup-id "i3lock-color --clock --indicator --blur 7x5 --pass-{media,screen,power,volume}-keys"'';
```

### Capture

Use scrot to take screenshots

```nix "modules/home/i3-packages" +=
scrot
```

Save (_print_) to file and copy (_yank_) to clipboard

- `z` to silently shot
- `p` for showing the pointer

`--release` is needed to allow selection

```nix "modules/home/i3" +=
i3AddNamedKeybinds.scrot = lib.concatMapAttrs (key: fn: {
  "--release ${modifier}+${key}" = fn "-zpu";       # Focused window
  "--release ${modifier}+Shift+${key}" = fn "-zps"; # Select area or window
  "--release ${modifier}+Ctrl+${key}" = fn "-zp";   # Whole screen
}) {
  p = let dir = "${config.xdg.userDirs.pictures}/Screenshots";
      in args: "exec --no-startup-id mkdir -p ${dir} && scrot ${args} -F '${dir}/%Y-%m-%d_%H%M%S.png'";
  y = args: "exec --no-startup-id scrot ${args} - | xclip -selection clipboard -t image/png";
};
```

## Clipboard

```nix "modules/home/i3-packages" +=
copyq
xclip
```

Start clipboard manager

```sh "modules/home/i3-startup" +=
{
  command = "${pkgs.copyq}/bin/copyq";
  notification = false;
}
```

Clipboard history picker

```nix "modules/home/i3" +=
i3AddKeybinds."${modifier}+q" = "exec copyq toggle";
```

## Floating windows

Enable floating by default for some applications

```nix "modules/home/i3-config" +=
floating.criteria =[
  { class = "[Ff]irefox"; title = "^Developer Tools [-—]"; }
  { class = "[Ff]ile-roller"; title = "Extract"; }
  { class = "[Ff]ile-roller"; title = "Compress"; }
  { title = "file Transfer.*"; }
  { class = "[Nn]emo"; title = "Properties"; }
  { class = "[Pp]avucontrol"; }
  { class = "[Qq]alculate-gtk"; }
  { class = "[Cc]opyq"; }
  { title = "MuseScore: Play Panel"; }
];
window.commands = [
  { criteria = { class = "[Ff]irefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
  { criteria = { class = "[Ff]irefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
];
```

## Polkit

```nix "modules/home/i3-packages" +=
polkit_gnome
```

## Border and gaps

```nix "modules/home/i3-config" +=
gaps.inner = 5;
```

Disable ugly borders

```nix "modules/home/i3-config" +=
window.border = 0;
floating.border = 0;
```

Disable titlebars

```nix "modules/home/i3-config" +=
window.titlebar = false;
floating.titlebar = false;
```

