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

## OpenTabletDriver config

```nix "home-config" +=
xdg.configFile."OpenTabletDriver/settings.json".source = ./tablet.json;
```

## State version

**DO NOT TOUCH!**

```nix "home-config" +=
home.stateVersion = "22.05";
```

