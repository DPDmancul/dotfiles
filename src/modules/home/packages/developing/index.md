# Developing

```nix modules/home/packages/developing/default.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    <<<modules/home/packages/developing/default-packages>>>
  ];
}
```

## Ghidra

Tool for decompiling shared objects to C and inspect compiler optimizations

```nix "modules/home/packages/developing/default-packages" +=
ghidra
```
