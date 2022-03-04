# Home

```nix home.nix
{ config, pkgs, lib, ... }:
{
  <<<home-config>>>
}
```

## Home directory

```nix "home-config" +=
home.username = "dpd-";
home.homeDirectory = "/home/dpd-";
```

## Environment

```nix "config" +=
home.sessionVariables = {
  <<<home-env>>>
};
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

