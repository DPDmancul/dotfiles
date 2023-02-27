# Polybar

Use polybar instead of i3bar

```nix modules/home/i3/polybar.nix
{ config, pkgs, lib, ... }: let
  # TODO create my lib
  concatMapToAttrs = f: with lib; flip pipe [ (map f) (foldl' mergeAttrs { }) ];
in
{
  xsession.windowManager.i3.config.bars = [];

  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = "polybar top &"; # TODO
    settings = rec {
      <<<modules/home/i3/polybar-settings>>>
    };
  };

 # <<<modules/home/i3/polybar>>>
}
```

## Colors

```nix "modules/home/i3/polybar-settings" +=
colors = {
  background = "#0000";
  foreground = "#161320";
  glass = "#A6F9F9F9";
  gold-opaque = "#EFB402";
  gold-opaque-dark = "#AB8203";
  red-opaque = "#E00804";
  gray-opaque = "#333";
  red = "#A6E8A2AF";
  purple = "#A6C9CBFF"; #idle
    yellow = "#A6FAE3B0";
  violet = "#A6BD93F9";
  lilla = "#A6DDB6F2";
  cyan = "#A696CDFB";
  salmon = "#A6F8BD96"; # temp
    azure = "#A6B5E8E0";
  green = "#A6ABE9B3";
};
```

## Top bar

```nix "modules/home/i3/polybar-settings" +=
"bar/top" = {
  background = "\${colors.background}";
  foreground = "\${colors.foreground}";

  height = "20px";
```

Bottom border is not required, since I use i3 with gaps

```nix "modules/home/i3/polybar-settings" +=
  border = {
    top.size = "4px";
    bottom.size = 0;
  };
  padding = "6px";

  module.margin = "4px";

  line.size = "4px"; # colored line under active workspace
```

Antialiasing for powerline is terrible: disable it 

```nix "modules/home/i3/polybar-settings" +=
  font = [
    # T1: text
    "JetbrainsMono Nerd Font:size=9;2"
    # T2: powerline
    "JetbrainsMono Nerd Font:antialias=false:size=11;2"
  ];

  modules = {
    left = "i3";
    center = "window";
    right = "volume eth wlan ram cpu battery clock"; # TODO idle
  };
  tray.position = "right";
};
```

### Common config for rounded corner

Emulate rounded corner with powerline chars

```nix "modules/home/i3/polybar-settings" +=
rounded = concatMapToAttrs (spec: {
  ${spec} = {
    prefix = {
      foreground = "\${self.${spec}-background}";
      background = "#0000";
      text = "";
      font = 2;
    };
    suffix = {
      foreground = "\${self.${spec}-background}";
      background = "#0000";
      text = "";
      font = 2;
    };
  };
}) [
  "format"
  "format-volume"
  "format-muted"
  "format-mounted"
  "format-unmounted"
  "format-connected"
  "format-disconnected"
  "content"
];
```

### i3 workspace and mode indicators

```nix "modules/home/i3/polybar-settings" +=
"module/i3" = {
  type = "internal/i3";
  pin.workspaces = true; # show only this monitor ws
  enable.scroll = false;

  label = concatMapToAttrs (spec: {
    ${spec} = {
      text = "%index%"; # do not show icon
      padding = "4px";
      background = "\${colors.glass}";
    };
  }) [
    "focused"
    "visible" # focused on antoher monitor
    "unfocused"
    "urgent"
  ];

  label-focused = {
    foreground = "\${colors.gold-opaque-dark}";
    underline = "\${colors.gold-opaque}";
  };
  label-visible = {
    foreground = "\${colors.gray-opaque}";
    underline = "\${colors.gray-opaque}";
  };
  label-urgent = {
    foreground = "\${colors.red-opaque}";
    underline = "\${colors.red-opaque}";
  };

  label-mode.background = "\${colors.red}";
```

Here we cannon inherit rounded, so we have to emulate it:

```nix "modules/home/i3/polybar-settings" +=
  format = "%{B#0000 F${colors.glass} T2}%{B${colors.glass} F${colors.foreground} T-}<label-state>%{B#0000 F${colors.glass} T2}%{B- F- T-} <label-mode>";
  label-mode.text = "%{B#0000 F${colors.red} T2}%{B${colors.red} F${colors.foreground} T-}%mode%%{B#0000 F${colors.red} T2}%{B- F- T-}";
};
```

### Window title

```nix "modules/home/i3/polybar-settings" +=
"module/window" = {
  type = "internal/xwindow";
  label = "%title:0:60:...%";
  "inherit" = "rounded";
  format.background = "\${colors.glass}";
};
```

### Volume

TODO: headphones 

```nix "modules/home/i3/polybar-settings" +=
"module/volume" = {
  type = "internal/pulseaudio";
  "inherit" = "rounded";
  format = {
    volume.text = "<ramp-volume> <label-volume>";
    volume.background = "\${colors.yellow}";
    muted.background = "\${colors.yellow}";
  };
  ramp.volume = [ "" "" "" ];
  label.muted = " ";
  click.right = "pavucontrol";
};
```

### Networking

Common facilities

```nix "modules/home/i3/polybar-settings" +=
net = {
  type = "internal/network";
  label.disconnected = "";
  format = {
    connected.background = "\${colors.violet}";
    disconnected.background = "\${colors.red}";
  };
  # TODO show ip on click
};
```

Wired

```nix "modules/home/i3/polybar-settings" +=
"module/eth" = {
  "inherit" = "net rounded";
  interface.type = "wired";
  label.connected = " %linkspeed%";
};
```

Wi-fi

```nix "modules/home/i3/polybar-settings" +=
"module/wlan" = {
  "inherit" = "net rounded";
  interface.type = "wireless";
  label.connected = " %essid:0:10:...% (%signal%%)";
};
```

### System monitor

```nix "modules/home/i3/polybar-settings" +=
"module/ram" = {
  type = "internal/memory";
  interval = 5;
  label = " %percentage_used%%";
  "inherit" = "rounded";
  format.background = "\${colors.lilla}";
};
"module/cpu" = {
  type = "internal/cpu";
  interval = 5;
  label = " %percentage%%";
  "inherit" = "rounded";
  format.background = "\${colors.cyan}";
};
```

### Battery

```nix "modules/home/i3/polybar-settings" +=
"module/battery" = rec {
  type = "internal/battery";
  time.format = "%H:%M";
  format = {
    charging = "<animation-charging> <label-charging>";
    discharging = "<ramp-capacity> <label-discharging>";
    full = "<ramp-capacity> <label-full>";
  };
  ramp.capacity = [ "" "" "" "" "" ];
  animation.charging = ramp.capacity;
  "inherit" = "rounded";
  format.background = "\${colors.azure}";
};
```

### Clock

```nix "modules/home/i3/polybar-settings" +=
"module/clock" = {
  type = "internal/date";
  date = {
    text = "%H:%M";
    alt = "%Y-%m-%d %H:%M:%S";
  };
  "inherit" = "rounded";
  format.background = "\${colors.green}";
};
```

## TODO Multi output


```nix "modules/home/i3/polybar-settings" +=
settings.screenchange.reload = true;
```



