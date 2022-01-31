# Home

```nix home.nix
{ config, pkgs, lib, ... }:
let
  nur = import (builtins.fetchTarball { 
    url = "https://github.com/nix-community/NUR/archive/master.tar.gz";
    sha256 = "0qbix64vp7smy93ibn0zzidgp817fyp0jqrsmk2la4h1877i6hyk";
  }) { inherit pkgs; };
in
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

