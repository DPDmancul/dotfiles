# i3

```nix modules/home/i3/default.nix
{ config, pkgs, lib, inputs, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;
  alt = "Mod1";
  vi-directions = {
    left = "h";
    down = "j";
    up = "k";
    right = "l";
  };
  arrow-directions = {
    left = "Left";
    down = "Down";
    up = "Up";
    right = "Right";
  };
in
{
```

The following option allows to declare keybindings in multiple places and to use
functional programming techniques to build them.

```nix modules/home/i3/default.nix +=
  options = {
    i3AddKeybinds =  with lib; mkOption {
      type = with types; attrsOf str;
      description = "Additional keybindings to the default ones.";
      default = { };
    };
    i3AddNamedKeybinds = with lib; mkOption {
      type = with types; attrsOf (attrsOf str);
      description = "Additional keybindings to the default ones.
        The keybinds are collected in a set whose names are discarded,
        and so can be used for organization purpose.";
      default = { };
      apply = x: (lib.concatMapAttrs (name: value: value) x) // config.i3AddKeybinds;
    };
  };
```

```nix modules/home/i3/default.nix +=
  imports = [
    ./picom.nix
    ./polybar.nix
    <<<modules/home/i3-imports>>>
  ];

  config = {
    xsession = {
      enable = true; # .xsession for lightDM
      windowManager.i3 = {
        enable = true;
        package = pkgs.unstable.i3; # TODO stable after gaps being merged
        config = {
          <<<modules/home/i3-config>>>
          startup = [
            <<<modules/home/i3-startup>>>
          ];
          keybindings = lib.mkOptionDefault config.i3AddNamedKeybinds;
        };
      };
    };

    <<<modules/home/i3>>>

    home.packages = with pkgs; [
      <<<modules/home/i3-packages>>>
    ];
  };
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
  # TODO config
};
```

```nix "modules/home/i3-config" +=
menu = "rofi -show drun";
```

### Poweroff

```nix "modules/home/i3" +=
i3AddKeybinds."${modifier}+Shift+e" = let
  rofi-exit = pkgs.writeShellScript "rofi-exit.sh"  ''
    case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | rofi -dmenu -p "Logout menu") in
      "Shutdown") systemctl poweroff;;
      "Suspend") systemctl suspend;;
      "Reboot") systemctl reboot;;
      "Logout") i3-msg exit;;
    esac
  '';
in
"exec ${rofi-exit}";
```

## Notifications

```nix "modules/home/i3" +=
services.dunst = {
  enable = true;
  # TODO config
};
```

## Volume

```nix "modules/home/i3" +=
i3AddKeybinds = {
  "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer --unmute --increase 5";
  "XF86AudioLowerVolume" = "exec --no-startup-id pamixer --decrease 5";
  "XF86AudioMute" = "exec --no-startup-id pamixer -t";
};
```

## Screen

### Brightness

Don't know why the following are triggered twice, so a step of 2 is indeed a step of 4.

```nix "modules/home/i3" +=
i3AddKeybinds = {
  "XF86MonBrightnessDown" = "exec --no-startup-id light -U 2";
  "XF86MonBrightnessUp" = "exec --no-startup-id light -A 2";
};
```

#### Red light

```nix "modules/home/i3" +=
services.gammastep = {
  enable = true;
  latitude = 46.; # North
  longitude = 13.; # East
  tray = false;
};
```

### Move window to another screen

```nix "modules/home/i3" +=
i3AddNamedKeybinds.moveToScreen = with lib; listToAttrs (concatMap
  (mapAttrsToList (name: value: nameValuePair "${modifier}+Ctrl+Shift+${value}" "move workspace to output ${name}"))
  [
    vi-directions
    arrow-directions
  ]
);
```

### Move focus and windows

Enable both vi and arrow mode for moving focus and windows

```nix "modules/home/i3" +=
i3AddNamedKeybinds.move = with lib; listToAttrs (concatLists (concatMap
  (mapAttrsToList
    (name: value: [
      (nameValuePair "${modifier}+${value}" "focus ${name}")
      (nameValuePair "${modifier}+Shift+${value}" "move ${name}")
    ])
  )
  [
    vi-directions
    arrow-directions
  ]
));
```

### Additional workspaces

```nix "modules/home/i3" +=
i3AddNamedKeybinds.additionalWS = with lib; listToAttrs (concatMap
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

Default workspace

```nix "modules/home/i3-config" +=
defaultWorkspace = "workspace number 1";
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

## Shortcuts

```nix "modules/home/i3" +=
i3AddNamedKeybinds.shortcuts = {
  "${modifier}+z" = "exec firefox";
  "${modifier}+x" = "exec nemo";
  "${modifier}+v" = "exec ${config.xsession.windowManager.i3.config.terminal} nvim";
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
  { class = "firefox"; title = "^Developer Tools [-—]"; }
  { class = "file-roller"; title = "Extract"; }
  { class = "file-roller"; title = "Compress"; }
  { class = "nemo"; title = "Properties"; }
  { class = "Pavucontrol"; }
  { class = "qalculate-gtk"; }
  { class = "copyq"; }
];
window.commands = [
  { criteria = { class = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
  { criteria = { class = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
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

## Background

Use random backgrounds with feh

```nix "flake-inputs" +=
feh-random-background = {
  url = github:KoviRobi/feh-random-background;
  flake = false;
};
wallpapers = {
  url = gitlab:DPDmancul/dotfiles-wallpapers;
  flake = false;
};
```

```nix "modules/home/i3-imports" +=
(inputs.feh-random-background + /home-manager-service.nix)
```

```nix "modules/home/i3" +=
services.feh-random-background = {
  enable = true;
  imageDirectory = "${inputs.wallpapers}";
  interval = "1m";
};
```

