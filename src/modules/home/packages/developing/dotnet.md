# DotNet

```nix modules/home/packages/developing/dotnet.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    dotnet-sdk
  ];
  <<<modules/home/packages/developing/dotnet>>>
}
```

## Neovim support

<!-- TODO Language server -->

```nix "modules/home/packages/developing/dotnet" +=
#programs.neovim.plugins = with pkgs.vimPlugins; [
#];
```

