# Rust

```nix modules/home/packages/developing/rust.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    cargo rustc clippy rustfmt
    gdb
  ];
  <<<modules/home/packages/developing/rust>>>
}
```

## Neovim support

<!-- TODO Language server -->

```nix "modules/home/packages/developing/rust" +=
#programs.neovim.plugins = with pkgs.vimPlugins; [
#];
```

