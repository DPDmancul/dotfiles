# Home

```nix home.nix
{ config, pkgs, lib, ... }:
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
  cd "${PWD}"
  nix-shell --run "make $*"
'')
```

## State version

**DO NOT TOUCH!**

```nix "home-config" +=
home.stateVersion = "22.05";
```

