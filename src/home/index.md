# Home

```nix home.nix
{ config, pkgs, lib, dotfiles, ... }:
let
  <<<home-let>>>
in {
  <<<home-config>>>
}
```

## Home directory

```nix "home-config" +=
home.username = "dpd-";
home.homeDirectory = "/home/dpd-";
```

## Dots utility

Quickly apply dotfiles

```nix "home-packages" +=
(writeShellScriptBin "dots" ''
  cd "${dotfiles}"
  nix-shell --run "make $*"
'')
```

## Environment

```nix "home-config" +=
home.sessionVariables = {
  <<<home-env>>>
};
home.sessionPath = [
  <<<home-path>>>
];
```

## Bluetooth headset battery

```nix "home-packages" +=
(writeShellScriptBin "batt" ''
  ${bluetooth_battery}/bin/bluetooth_battery AC:12:2F:50:BB:3A
'')
```

## OpenTabletDriver config

```nix "home-config" +=
xdg.configFile."OpenTabletDriver/settings.json".source = ./tablet.json;
```

## State version

**DO NOT TOUCH!**

```nix "home-config" +=
home.stateVersion = "22.05";
```

