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

```nix "env" +=
XDG_CURRENT_DESKTOP = "sway";
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

```nix "sway-keybind" +=
"--locked XF86MonBrightnessDown" = "exec light -U 5";
"--locked XF86MonBrightnessUp" = "exec light -A 5";
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

## Clipboard

```nix "home-packages" +=
wl-clipboard
```

Add clipboard support to X11 programs

```nix "home-config" +=
nixpkgs.overlays = [
  (self: super: {
    wl-clipboard-x11 = super.stdenv.mkDerivation rec {
      pname = "wl-clipboard-x11";
      version = "5";

      src = super.fetchFromGitHub {
        owner = "brunelli";
        repo = "wl-clipboard-x11";
        rev = "v${version}";
        sha256 = "1y7jv7rps0sdzmm859wn2l8q4pg2x35smcrm7mbfxn5vrga0bslb";
      };

      dontBuild = true;
      dontConfigure = true;
      propagatedBuildInputs = [ super.wl-clipboard ];
      makeFlags = [ "PREFIX=$(out)" ];
    };

    xsel = self.wl-clipboard-x11;
    xclip = self.wl-clipboard-x11;
  })
];
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
  { app_id = "pavucontrol"; }
  { app_id = "qalculate-gtk"; }
];
```

## Polkit

```nix "home-packages" +=
polkit_gnome
```

## Import environment variables

```nix "sway-extraconfig"
exec dbus-update-activation-environment WAYLAND_DISPLAY
exec systemctl --user import-environment WAYLAND_DISPLAY
exec dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus
```



