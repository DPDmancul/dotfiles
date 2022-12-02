# Python3

```nix modules/home/packages/developing/python3.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    python3
  ];
  <<<modules/home/packages/developing/python3>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/python3" +=
nvimLSP.pyright = pkgs.nodePackages.pyright;
```

