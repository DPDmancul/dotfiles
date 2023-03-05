# i3 keybinds

```nix modules/home/i3/keybinds.nix
{ config, pkgs, lib, inputs, ... }:
let
  inherit (config.xsession.windowManager.i3.config) modifier;
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

```nix modules/home/i3/keybinds.nix +=
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

```nix modules/home/i3/keybinds.nix +=
  config = {
    xsession.windowManager.i3.config = {
      <<<modules/home/i3/keybinds-config>>>
      keybindings = lib.mkOptionDefault config.i3AddNamedKeybinds;
    };

    <<<modules/home/i3/keybinds>>>
  };
}
```

## Window management

### Move focus and windows

Enable both vi and arrow mode for moving focus and windows

```nix "modules/home/i3/keybinds" +=
i3AddNamedKeybinds.move = lib.concatMapPairToAttrs
  (name: value: {
    "${modifier}+${value}" = "focus ${name}";
    "${modifier}+Shift+${value}" = "move ${name}";
  })
  [
    vi-directions
    arrow-directions
  ];
```

### Move window to another screen

```nix "modules/home/i3/keybinds" +=
i3AddNamedKeybinds.moveToScreen = lib.concatMapPairToAttrs
  (name: value: {
    "${modifier}+Ctrl+Shift+${value}" = "move workspace to output ${name}";
  })
  [
    vi-directions
    arrow-directions
  ];
```

### Resize windows

Enable both vi and arrow mode for resizing windows, also more granularly than default.

```nix "modules/home/i3/keybinds-config" +=
modes.resize = {
  Escape = "mode default";
  Return = "mode default";
} // lib.concatMapToAttrs
  ({left, down, up, right}: {
    ${left} = "resize shrink width 10 px";
    ${right} = "resize grow width 10 px";
    ${down} = "resize shrink height 10 px";
    ${up} = "resize grow height 10 px";
  })
  [
    vi-directions
    arrow-directions
  ];
```

### Split orientation

Since `Super + h` is already used to move focus, and `Super + v` to open neovim, add a shift to change split orientation.

```nix "modules/home/i3/keybinds" +=
i3AddKeybinds = {
  "${modifier}+Shift+h" = "split h";
  "${modifier}+Shift+v" = "split v";
};
```

### Sticky windows

Toggle a window to be sticky on all workspaces
```nix "modules/home/i3/keybinds" +=
i3AddKeybinds = {
  "${modifier}+Shift+s" = "sticky toggle";
};
```

### Additional workspaces

```nix "modules/home/i3/keybinds" +=
i3AddNamedKeybinds.additionalWS = with lib; concatMapAttrs
  (name: value:
    let
      ws = toString value;
    in
    {
      "${modifier}+${name}" = "workspace number ${ws}";
      "${modifier}+Shift+${name}" = "move container to workspace number ${ws}";
      "${modifier}+Ctrl+${name}" = "move container to workspace number ${ws}, workspace number ${ws}";
    })
  ({
    "grave" = 0;
    "Escape" = 10;
  } // (concatMapToAttrs
    (n: { ${toString n} = n; })
    [ 1 2 3 4 5 6 7 8 9 ])
  // concatMapToAttrs
    (n: { "F${toString n}" = (10 + n); })
    [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
  );
```

Default workspace

```nix "modules/home/i3/keybinds-config" +=
defaultWorkspace = "workspace number 1";
```


## Shortcuts

```nix "modules/home/i3/keybinds" +=
i3AddNamedKeybinds.shortcuts = {
  "${modifier}+z" = "exec firefox";
  "${modifier}+x" = "exec nemo";
  "${modifier}+v" = "exec ${config.xsession.windowManager.i3.config.terminal} nvim";
};
```

## System

### Volume

```nix "modules/home/i3/keybinds" +=
i3AddKeybinds = {
  "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer --unmute --increase 5";
  "XF86AudioLowerVolume" = "exec --no-startup-id pamixer --decrease 5";
  "XF86AudioMute" = "exec --no-startup-id pamixer -t";
};
```

### Brightness

Don't know why the following are triggered twice, so a step of 2 is indeed a step of 4.

```nix "modules/home/i3/keybinds" +=
i3AddKeybinds = {
  "XF86MonBrightnessDown" = "exec --no-startup-id light -U 2";
  "XF86MonBrightnessUp" = "exec --no-startup-id light -A 2";
};
```

### Poweroff

```nix "modules/home/i3/keybinds" +=
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

