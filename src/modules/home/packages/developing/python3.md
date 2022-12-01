# Python3

```nix modules/home/packages/developing/python3.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    python3
  ];
  <<<modules/home/packages/developing/python3>>>
}
```

## Neovim support

<!-- TODO Language server -->

```nix "modules/home/packages/developing/python3" +=
#programs.neovim.plugins = with pkgs.vimPlugins; [
#];
```

