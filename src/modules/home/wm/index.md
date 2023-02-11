# Sway and i3

Common config for sway and i3

```nix modules/home/wm/default.nix
{ config, pkgs, lib, ... }:
let
  common-options = wm: lib.mkMerge [
    {
      <<<modules/home/wm-common>>>
      extraConfig = ''
        <<<modules/home/wm-common-extra-config>>>
      '';
    }
  ];
  inherit (config.wayland.windowManager.sway.config) modifier left down up right;
in
{
```

The following option allows to declare keybindings in multiple places and to use
functional programming techniques to build them.

```nix modules/home/wm/default.nix +=
  options = {
    sway-i3AddKeybinds =  with lib; mkOption {
      type = with types; attrsOf (oneOf [ str (attrsOf str) ]);
      description = "Additional keybindings to the default ones.
        You can optionally specify different execs for each wm.";
      default = { };
    };
    sway-i3AddNamedKeybinds = with lib; mkOption {
      type = with types; attrsOf (attrsOf (oneOf [ str (attrsOf str) ]));
      description = "Additional keybindings to the default ones.
        You can optionally specify different execs for each wm.
        The keybinds are collected in a set whose names are discarded,
        and so can be used for organization purpose.";
      default = { };
      apply = x: (lib.concatMapAttrs (name: value: value) x) // config.sway-i3AddKeybinds;
    };
  };
```

```nix  modules/home/wm/default.nix +=
  config = {
    wayland.windowManager.sway = common-options "sway";
    xsession.windowManager.i3 = common-options "i3";

    <<<modules/home/wm>>>

    home.packages = with pkgs; [
      <<<modules/home/wm-packages>>>
    ];
  };
}
```

- Filter only keybinds for current wm
- Remove `--locked` option form i3

```nix "modules/home/wm-common" +=
config.keybindings = lib.mkOptionDefault
  (lib.mapAttrs' (name: value: lib.nameValuePair (if wm == "i3" then lib.removePrefix "--locked " name else name) (value."${wm}" or value))
    (lib.filterAttrs (name: value: builtins.isString value || value ? "${wm}") config.sway-i3AddNamedKeybinds));
```

## Modifier key

Use super as mod key

```nix "modules/home/wm-common" +=
config.modifier = "Mod4";
```

## Terminal

```nix "modules/home/wm-common" +=
config.terminal = "kitty";
```

## Application launcher

```nix "modules/home/wm" +=
programs.rofi = {
  enable = true;
  package = pkgs.rofi-wayland;
  terminal = "${pkgs.kitty}/bin/kitty";
  extraConfig = {
    show-icons = true;
  };
  # TODO config
};
```

```nix "modules/home/wm-common" +=
config.menu = ''rofi -show drun'';
```

### Poweroff

```nix "modules/home/wm" +=
sway-i3AddKeybinds."${modifier}+Shift+e" = let
  rofi-exit = logout: pkgs.writeShellScript "rofi-exit.sh"  ''
    case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | rofi -dmenu -p "Logout menu") in
      "Shutdown") systemctl poweroff;;
      "Suspend") systemctl suspend;;
      "Reboot") systemctl reboot;;
      "Logout") ${logout};;
    esac
  '';
in
{
  sway = "exec ${rofi-exit "swaymsg exit"}";
  i3 = "exec ${rofi-exit "i3-msg exit"}";
};
```

## Notifications

```nix "modules/home/wm" +=
services.dunst = {
  enable = true;
  # TODO config
};
```

## Volume

```nix "modules/home/wm" +=
sway-i3AddKeybinds = {
  "--locked XF86AudioRaiseVolume" = "exec pamixer -u -i 5";
  "--locked XF86AudioLowerVolume" = "exec pamixer -d 5";
  "--locked XF86AudioMute" = "exec pamixer -t";
};
```

## Screen

### Brightness

Don't know why the following are triggered twice, so a step of 2 is indeed a step of 4.

```nix "modules/home/wm" +=
sway-i3AddKeybinds = {
  "--locked XF86MonBrightnessDown" = "exec light -U 2";
  "--locked XF86MonBrightnessUp" = "exec light -A 2";
};
```

#### Red light

```nix "modules/home/wm" +=
services.gammastep = {
  enable = true;
  latitude = 46.; # North
  longitude = 13.; # East
  tray = false;
};
```

### Move to another screen

```nix "modules/home/wm" +=
sway-i3AddNamedKeybinds.moveToScreen = with lib; listToAttrs (concatMap
  (mapAttrsToList (name: value: nameValuePair "${modifier}+Ctrl+Shift+${value}" "move workspace to output ${name}"))
  [
    { inherit left down up right; }
    { left = "Left"; down = "Down"; up = "Up"; right = "Right"; }
  ]
);
```

### Move focus and windows

Enable both vi and arrow mode for moving focus and windows

```nix "modules/home/wm" +=
sway-i3AddNamedKeybinds.move = with lib; listToAttrs (concatLists (concatMap
  (mapAttrsToList
    (name: value: [
      (nameValuePair "${modifier}+${value}" "focus ${name}")
      (nameValuePair "${modifier}+Shift+${value}" "move ${name}")
    ])
  )
  [
    { inherit left down up right; }
    { left = "Left"; down = "Down"; up = "Up"; right = "Right"; }
  ]
));
```

### Additional workspaces

```nix "modules/home/wm" +=
sway-i3AddNamedKeybinds.additionalWS = with lib; listToAttrs (concatMap
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

```nix "modules/home/wm-common" +=
config.defaultWorkspace = "workspace number 1";
```

<!--
### Lock

```nix "TODO-modules/home/wm/sway-packages" +=
swaylock-effects
```

```nix "TODO-modules/home/wm/sway" +=
swayAddKeybinds."Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
```

### Idle

```nix "TODO-modules/home/wm/sway" +=
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

```nix "TODO-modules/home/wm/sway-packages" +=
sway-contrib.grimshot
```

Save (_print_) to file and copy (_yank_) to clipboard

```nix "TODO-modules/home/wm/sway" +=
swayAddNamedKeybinds.grimshot = lib.concatMapAttrs (key: func: {
  "${modifier}+${key}" = "exec grimshot ${func} active";       # Active window
  "${modifier}+Shift+${key}" = "exec grimshot ${func} area";   # Select area
  "${modifier}+Mod1+${key}" = "exec grimshot ${func} output";  # Whole screen
  "${modifier}+Ctrl+${key}" = "exec grimshot ${func} window";  # Choose window
}) { p = "save"; y = "copy"; };
```
-->

## Shortcuts

```nix "modules/home/wm" +=
sway-i3AddNamedKeybinds.shortcuts = {
  "${modifier}+z" = "exec firefox";
  "${modifier}+x" = "exec nemo";
  "${modifier}+v" = "exec kitty nvim";
};
```

## Clipboard

```nix "modules/home/wm-packages" +=
copyq
```

Start clipboard manager

```sh "modules/home/wm-common-extra-config" +=
exec ${pkgs.copyq}/bin/copyq
```

Clipboard history picker

```nix "modules/home/wm" +=
sway-i3AddKeybinds."${modifier}+q" = "exec copyq toggle";
```

## Floating windows

Enable floating by default for some applications

```nix "modules/home/wm-common" +=
config.floating.criteria = let
  class = if wm == "sway" then "app_id" else "class";
in
[
  { ${class} = "firefox"; title = "^Developer Tools [-—]"; }
  { ${class} = "file-roller"; title = "Extract"; }
  { ${class} = "file-roller"; title = "Compress"; }
  { ${class} = "nemo"; title = "Properties"; }
  { ${class} = "pavucontrol"; }
  { ${class} = "qalculate-gtk"; }
  { ${class} = "copyq"; }
];
config.window.commands = let
  class = if wm == "sway" then "app_id" else "class";
in
[
  { criteria = { ${class} = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
  { criteria = { ${class} = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
  # { criteria = { shell = "xwayland"; }; command = ''title_format "%title [%shell]"''; } # TODO: does not work for waybar
];
```

## Polkit

```nix "modules/home/wm-packages" +=
polkit_gnome
```

## Border and gaps

```nix "modules/home/wm-common" +=
config.gaps.inner = 5;
```

Disable border for inactive windows and for alone ones

```nix "modules/home/wm-common" +=
# TODO transaprent not working in i3
config.colors.unfocused = let transparent = "#00000000"; in {
  background = "#222222";
  border = transparent;
  childBorder = transparent;
  indicator = "#292d2e";
  text = "#888888";
};
config.gaps.smartBorders = "on";
```

Disable titlebars

```nix "modules/home/wm-common" +=
config.window.titlebar = false;
```

## Background <!-- TODO -->

Use wpaperd for random backgrounds

```nix "modules/home/wm/sway-packages" +=
unstable.wpaperd
```

```nix "modules/home/wm/sway" +=
xdg.configFile."wpaperd/output.conf".text = ''
  [default]
  path = "${inputs.wallpapers}"
  duration = "1m"
'';
```

```sh "modules/home/wm/sway-extra-config" +=
exec ${pkgs.unstable.wpaperd}/bin/wpaperd
```

