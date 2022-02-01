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

## State version

**DO NOT TOUCH!**

```nix "home-config" +=
home.stateVersion = "22.05";
```

