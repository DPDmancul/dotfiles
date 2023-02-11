# Sway

```nix modules/home/wm/sway.nix
{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./default.nix
    ./waybar.nix
  ];

  config = let
    inherit (config.wayland.windowManager.sway.config) modifier left down up right;
  in
  {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        <<<modules/home/wm/sway-config>>>
      };
      extraConfig = ''
        <<<modules/home/wm/sway-extra-config>>>
      '';
    };

    home.packages = with pkgs; [
      <<<modules/home/wm/sway-packages>>>
    ];

    <<<modules/home/wm/sway>>>
  };
}
```

```nix "modules/home/wm/sway" +=
home.sessionVariables.XDG_CURRENT_DESKTOP = "sway";
```

## Keyboard

```nix "modules/home/wm/sway-config" +=
input."*" = {
  xkb_layout = "eu"; # TODO take from system config
  xkb_numlock = if config.xsession.numlock.enable then "enabled" else "disabled";
};
```

## Screen

### Lock

```nix "modules/home/wm/sway-packages" +=
swaylock-effects
```

```nix "modules/home/wm/sway" +=
sway-i3AddKeybinds."Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
```

### Idle

```nix "modules/home/wm/sway" +=
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

```nix "modules/home/wm/sway-packages" +=
sway-contrib.grimshot
```

Save (_print_) to file and copy (_yank_) to clipboard

```nix "modules/home/wm/sway" +=
sway-i3AddNamedKeybinds.grimshot = lib.concatMapAttrs (key: func: {
  "${modifier}+${key}" = "exec grimshot ${func} active";       # Active window
  "${modifier}+Shift+${key}" = "exec grimshot ${func} area";   # Select area
  "${modifier}+Mod1+${key}" = "exec grimshot ${func} output";  # Whole screen
  "${modifier}+Ctrl+${key}" = "exec grimshot ${func} window";  # Choose window
}) { p = "save"; y = "copy"; };
```

## Clipboard

```nix "modules/home/wm/sway-packages" +=
wl-clipboard
# wl-clipboard-x11
```

