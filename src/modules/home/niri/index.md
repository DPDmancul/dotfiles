# Niri

```nix modules/home/niri/default.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ./keybinds.nix
    ./windows.nix
    ./waybar.nix
  ];

  xdg.configFile."niri/config.kdl".text = ''
    <<<modules/home/niri-config>>>
  '';

  <<<modules/home/niri>>>

  home.packages = with pkgs; [
    niri
    polkit_gnome
    # swaybg
    xwayland-satellite
    # <<<modules/home/niri-packages>>>
  ];
}
```

## Application launcher

```nix "modules/home/niri" +=
programs.fuzzel = {
  enable = true;
  settings.colors = {
    background = "fbf1c7ff";
    text = "3c3836ff";
    match = "9d0006ff";
    selection = "ebdbb2ff";
    selection-text = "3c3836ff";
    selection-match = "9d0006ff";
    border = "af3a0300";
  };
};
```

## Notifications

```nix "modules/home/niri" +=
services.mako = {
  enable = true;
  settings = {
    border-radius = 12;
    icon-path = "${config.gtk.iconTheme.package}/usr/share/icons/${config.gtk.iconTheme.name}";
  };
};
```

## Screen

### Red light

```nix "modules/home/niri" +=
services.gammastep = {
  enable = true;
  latitude = 46.; # North
  longitude = 13.; # East
  tray = false;
};
```

### Lock

```nix "modules/home/niri" +=
programs.swaylock = {
  enable = true;
  package = pkgs.swaylock-effects;
  settings = {
    screenshots = true;
    clock = true;
    indicator = true;
    effect-blur = "7x5";
    fade-in = 0.2;
  };
};
```

## Clipboard

```nix "modules/home/niri" +=
services.copyq = {
  enable = true;
  forceXWayland = false;
};
```

### Idle

```nix "modules/home/niri" +=
services.swayidle = {
  enable = true;
  timeouts = [
    {
      timeout = 300;
      command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
      # resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
    }
  ];
};
```

## Config

```kdl "modules/home/niri-config" +=
input {
  keyboard {
    numlock
  }

  touchpad {
    tap
    dwt // disable when typing
    drag true
    drag-lock
    scroll-method "two-finger"
  }

  focus-follows-mouse max-scroll-amount="10%"
}

screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
```

