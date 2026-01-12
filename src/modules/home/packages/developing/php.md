# PHP

```nix modules/home/packages/developing/php.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    php
  ];

  <<<modules/home/packages/developing/php>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/php" +=
nvimLSP.phpactor = pkgs.phpactor;
```

