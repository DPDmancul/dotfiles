# Waybar

Use waybar instead of swaybar

```nix "sway-config" +=
bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
```

```nix "home-config" +=
programs.waybar = {
  enable = true;
  settings = [
    {
      modules = null;
      <<<waybar-bar-settings>>>
    }
  ];
  style = ''
      <<<waybar-bar-css>>>
  '';
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
  # "backlight"
  # "keyboard-state"
  # "sway/language"
  "battery"
  "battery#bat2"
  "clock"
  "tray"
];
```

### Clock

```nix "waybar-bar-settings" +=
clock = {
  tooltip-format = "{: %H:%M:%S\n %Y/%m/%d\n<big>%Y %B</big>}\n<tt><small>{calendar}</small></tt>";
  format = "{:%H:%M}";
  format-alt = "{:%H:%M:%S}";
  interval = 1;
};
```

### Pulse audio

```nix "waybar-bar-settings" +=
pulseaudio = {
  format = "{volume}% {icon}";
  format-bluetooth = "{volume}% {icon} ";
  format-bluetooth-muted = "  ";
  # format-bluetooth-muted = " {icon}";
  format-muted = "";
  on-click = "pamixer -t";
  on-click-right = "pavucontrol";
  format-icons = {
    default = ["" "" ""];
    headphones = "";
    # handsfree = "";
    # headset = "";
    phone = "";
    portable = "";
    car = "";
  };
};
```

### System monitor

```nix "waybar-bar-settings" +=
cpu = {
  format = "{usage}% ";
};
memory = {
  format = "{}% ";
};
temperature = {
  critical-threshold = 80;
  format = "{temperatureC}°C {icon}";
  format-icons = ["" "" ""];
};
```

### Network

```nix "waybar-bar-settings" +=
network = {
  format-wifi = "{essid} ({signalStrength}%) ";
  format-ethernet = "{ipaddr}/{cidr} ";
  tooltip-format = "{ifname} via {gwaddr} ﯱ";
  format-linked = "{ifname} (No IP) ﯳ";
  format-disconnected = "";
  format-alt = "{ifname}: {ipaddr}/{cidr}";
};
```

### Battery and backlight

```nix "waybar-bar-settings" +=
battery = {
  states = {
    good = 95;
    warning = 30;
    critical = 20;
  };
  format = "{capacity}% {icon}";
  format-charging = "{capacity}% ";
  format-plugged = "{capacity}% ";
  format-alt = "{time} {icon}";
  format-icons = ["" "" "" "" ""];
  on-scroll-up = "light -A 5";
  on-scroll-down = "light -U 5";
};
idle_inhibitor = {
  format = "{icon}";
  format-icons = {
    deactivated = "鈴";
    activated = "零";
  };
};
```

## Style

```nix "waybar-bar-settings" +=
height = 20;
spacing = 0;
```

The style was taken from <https://github.com/theCode-Breaker/riverwm/blob/main/waybar/river/river_style.css>
with some small changes

```css "waybar-bar-css" +=
* {
  border: none;
  border-radius: 10px;
  font-family: "JetbrainsMono Nerd Font" ;
  font-size: 12px;
  color: #161320;
  min-height: 10px;
}

window#waybar {
  background: transparent;
}

window#waybar.hidden {
  opacity: 0.2;
}

tooltip label {
  color: white;
}

#window {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 10px;
  padding-right: 10px;
  margin-bottom: 0px;
  transition: none;
  background: rgba(249, 249, 249, 0.65);
}
#waybar.empty #window {
  background: transparent;
}

#workspaces {
  margin-top: 3px;
  margin-left: 4px;
  margin-bottom: 0px;
  background: rgba(249, 249, 249, 0.65);
  transition: none;
}

#workspaces button {
  transition: none;
  background: transparent;
  min-width: 16px;
  padding: 4px;
}

#workspaces button.focused {
  background: rgba(249, 249, 249, 0.4);
}

#workspaces button:hover {
  background: rgba(193, 193, 193, 0.65);
}

#network {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 12px;
  margin-bottom: 0px;
  transition: none;
  background: #bd93f9;
}

#pulseaudio {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 12px;
  margin-bottom: 0px;
  transition: none;
  color: #1A1826;
  background: #FAE3B0;
}

#battery {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 12px;
  margin-bottom: 0px;
  transition: none;
  background: #B5E8E0;
}

#battery.charging, #battery.plugged {
  background-color: #B5E8E0;
}

#battery.critical:not(.charging) {
  background-color: #B5E8E0;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

@keyframes blink {
  to {
    background-color: #BF616A;
    color: #B5E8E0;
  }
}

#temperature {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 10px;
  margin-bottom: 0px;
  transition: none;
  background: #F8BD96;
}
#clock {
  margin-top: 3px;
  margin-left: 4px;
  margin-right: 4px;
  padding-left: 10px;
  padding-right: 10px;
  margin-bottom: 0px;
  transition: none;
  background: #ABE9B3;
  /*background: #1A1826;*/
}

#memory {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 12px;
  margin-bottom: 0px;
  transition: none;
  background: #DDB6F2;
}
#cpu {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 12px;
  margin-bottom: 0px;
  transition: none;
  background: #96CDFB;
}

#tray {
  margin-top: 3px;
  margin-left: 0px;
  margin-right: 4px;
  padding-left: 10px;
  margin-bottom: 0px;
  padding-right: 10px;
  transition: none;
  color: #B5E8E0;
  background: #161320;
}

#custom-launcher {
  font-size: 24px;
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 10px;
  padding-right: 5px;
  transition: none;
  color: #89DCEB;
  background: #161320;
}

#custom-power {
  font-size: 20px;
  margin-top: 3px;
  margin-left: 4px;
  margin-right: 4px;
  padding-left: 10px;
  padding-right: 5px;
  margin-bottom: 0px;
  transition: none;
  background: #F28FAD;
}

#idle_inhibitor {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 8px;
  padding-right: 12px;
  margin-bottom: 0px;
  transition: none;
  background: #C9CBFF;
}

#mode {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 10px;
  padding-right: 10px;
  margin-bottom: 0px;
  transition: none;
  background: #E8A2AF;
}

#custom-media {
  margin-top: 3px;
  margin-left: 4px;
  padding-left: 10px;
  padding-right: 10px;
  margin-bottom: 0px;
  transition: none;
  background: #F2CDCD;
}
```
