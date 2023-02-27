# DotNet

```nix modules/home/packages/developing/dotnet.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    dotnet-sdk
  ];

  home.sessionVariables = {
    DOTNET_ROOT = pkgs.dotnet-sdk;
    # disable telemetry
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
  };

  <<<modules/home/packages/developing/dotnet>>>
}
```

## Neovim support

You have to manually install the language server:

```bash
dotnet tool install --global csharp-ls
```

```nix "modules/home/packages/developing/dotnet" +=
nvimLSP.csharp_ls = [];
home.sessionPath = [
  "${config.home.homeDirectory}/.dotnet/tools"
];
```
