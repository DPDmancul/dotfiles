# Haskell

```nix modules/home/packages/developing/haskell.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ghc
    haskell-language-server
  ];
  <<<modules/home/packages/developing/haskell>>>
}
```

### Neovim support

```nix "modules/home/packages/developing/haskell" +=
programs.neovim.plugins = with pkgs.vimPlugins; [
  haskell-tools-nvim
];
```

