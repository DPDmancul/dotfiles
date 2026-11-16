# Rust

```nix modules/home/packages/developing/rust.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    cargo rustc clippy rustfmt
    gdb
  ];
  <<<modules/home/packages/developing/rust>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/rust" +=
nvimLSP.rust_analyzer = pkgs.rust-analyzer;
```

