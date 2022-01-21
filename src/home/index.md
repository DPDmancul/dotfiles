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

## Self management

Let Home Manager install and manage itself.

```nix "home-config" +=
programs.home-manager.enable = true;
```

## State version

**DO NOT TOUCH!**

```nix "home-config" +=
home.stateVersion = "22.05";
```

