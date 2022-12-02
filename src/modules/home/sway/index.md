# Sway

```nix modules/home/sway/default.nix
{ config, options, pkgs, lib, dotfiles, ... }:
{
  imports = [
    ./waybar.nix
  ];
```

The following option allows to declare sway keybindings in multiple places and to use
functional programming techniques to build them.

```nix modules/home/sway/default.nix +=
  options = {
    swayAddKeybinds =  with lib; mkOption {
      type = with types; attrsOf str;
      description = "Additional keybindings to the default ones.";
      default = { };
    };
    swayAddNamedKeybinds = with lib; mkOption {
      type = with types; attrsOf (attrsOf str);
      description = "Additional keybindings to the default ones.
        The keybinds are collected in a set whose names are discarded,
        and so can be used for organization purpose.";
      default = { };
      apply = x: (lib.concatMapAttrs (name: value: value) x) // config.swayAddKeybinds;
    };
  };
```

```nix modules/home/sway/default.nix +=
  config = let
    inherit (config.wayland.windowManager.sway.config) modifier left down up right;
  in
  {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        <<<modules/home/sway-config>>>
        keybindings = lib.mkOptionDefault config.swayAddNamedKeybinds;
      };
      extraConfig = ''
        <<<modules/home/sway-extra-config>>>
      '';
    };

    home.packages = with pkgs; [
      <<<modules/home/sway-packages>>>
    ];

    <<<modules/home/sway>>>
  };
}
```

```nix "modules/home/sway" +=
home.sessionVariables.XDG_CURRENT_DESKTOP = "sway";
```

## Auto startup

```nix "modules/home/sway" +=
programs.fish.loginShellInit = lib.mkBefore ''
  if test (tty) = /dev/tty1
    exec sway &> /dev/null
  end
'';
```

## Modifier key

Use super as mod key

```nix "modules/home/sway-config" +=
modifier = "Mod4";
```

## Keyboard layout

Use the European variant of the international keyboard

```nix "modules/home/sway-config" +=
input."*".xkb_layout = "eu";
```

Enable Num Lock at startup

```nix "modules/home/sway-config" +=
input."*".xkb_numlock = "enabled";
```

## Terminal

```nix "modules/home/sway-config" +=
terminal = "kitty";
```

## Application launcher

```nix "modules/home/sway-packages" +=
wofi
```

```nix "modules/home/sway-config" +=
menu = ''wofi --show=drun -i --prompt=""'';
```

```nix "modules/home/sway" +=
xdg.configFile."wofi/config".text = ''
  allow_images=true # Enable icons
  insensitive=true  # Case insensitive search
'';
```

### Poweroff

```nix "modules/home/sway" +=
swayAddKeybinds."${modifier}+Shift+e" = ''
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

```nix "modules/home/sway" +=
programs.mako = {
  enable = true;
};
```

## Volume

```nix "modules/home/sway" +=
swayAddKeybinds = {
  "--locked XF86AudioRaiseVolume" = "exec pamixer -u -i 5";
  "--locked XF86AudioLowerVolume" = "exec pamixer -d 5";
  "--locked XF86AudioMute" = "exec pamixer -t";
};
```

## Screen

### Brightness

Don't know why the following are triggered twice, so a step of 2 is indeed a step of 4.

```nix "modules/home/sway" +=
swayAddKeybinds = {
  "--locked XF86MonBrightnessDown" = "exec light -U 2";
  "--locked XF86MonBrightnessUp" = "exec light -A 2";
};
```

#### Red light

```nix "modules/home/sway" +=
services.wlsunset = {
  enable = true;
  latitude = "46"; # North
  longitude = "13"; # East
};
```

### Autorandr

```nix "modules/home/sway" +=
services.kanshi = {
  enable = true;
};
```

### Move to another screen

```nix "modules/home/sway" +=
swayAddNamedKeybinds.moveToScreen = with lib; listToAttrs (concatMap ({ left, down, up, right }: [
    (nameValuePair "${modifier}+Ctrl+Shift+${left}" "move workspace to output left")
    (nameValuePair "${modifier}+Ctrl+Shift+${down}" "move workspace to output down")
    (nameValuePair "${modifier}+Ctrl+Shift+${up}" "move workspace to output up")
    (nameValuePair "${modifier}+Ctrl+Shift+${right}" "move workspace to output right")
  ]) [
    { inherit left down up right; }
    { left = "Left"; down = "Down"; up = "Up"; right = "Right"; }
  ]
);
```

### Additional workspaces

```nix "modules/home/sway" +=
swayAddNamedKeybinds.additionalWS = with lib; listToAttrs (concatMap
  ({ name, value }:
    let
      ws = toString value;
    in
    [
      (nameValuePair "${modifier}+${name}" "workspace number ${ws}")
      (nameValuePair "${modifier}+Shift+${name}" "move container to workspace number ${ws}")
      (nameValuePair "${modifier}+Ctrl+${name}" "move container to workspace number ${ws}, workspace number ${ws}")
    ])
  ([
    (nameValuePair "grave" 0)
    (nameValuePair "Escape" 10)
  ] ++ (map
    (n: nameValuePair (toString n) n)
    [ 1 2 3 4 5 6 7 8 9 ])
  ++ map
    (n: nameValuePair "F${toString n}" (10 + n))
    [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
  )
);
```

### Lock

```nix "modules/home/sway-packages" +=
swaylock-effects
```

```nix "modules/home/sway" +=
swayAddKeybinds."Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
```

### Idle

```nix "modules/home/sway" +=
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

```nix "modules/home/sway-packages" +=
sway-contrib.grimshot
```

Save (_print_) to file and copy (_yank_) to clipboard

```nix "modules/home/sway" +=
swayAddNamedKeybinds.grimshot = lib.concatMapAttrs (key: func: {
  "${modifier}+${key}" = "exec grimshot ${func} active";       # Active window
  "${modifier}+Shift+${key}" = "exec grimshot ${func} area";   # Select area
  "${modifier}+Mod1+${key}" = "exec grimshot ${func} output";  # Whole screen
  "${modifier}+Ctrl+${key}" = "exec grimshot ${func} window";  # Choose window
}) { p = "save"; y = "copy"; };
```

## Shortcuts

```nix "modules/home/sway" +=
swayAddNamedKeybinds.shortcuts = {
  "${modifier}+z" = "exec firefox";
  "${modifier}+x" = "exec nemo";
  "${modifier}+v" = "exec kitty nvim";
};
```

## Clipboard

```nix "modules/home/sway-packages" +=
wl-clipboard
wl-clipboard-x11
copyq
```

Start clipboard manager

```sh "modules/home/sway-extra-config" +=
exec ${pkgs.copyq}/bin/copyq
```

Clipboard history picker

```nix "modules/home/sway" +=
swayAddKeybinds."${modifier}+q" = "exec copyq toggle";
```

## Floating windows

Enable floating by default for some applications

```nix "modules/home/sway-config" +=
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

```nix "modules/home/sway-packages" +=
polkit_gnome
```

