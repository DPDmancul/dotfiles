# Developing

```nix modules/home/packages/developing/default.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    <<<modules/home/packages/developing/default-packages>>>
  ];

  <<<modules/home/packages/developing/default>>>
}
```

## Ghidra

Tool for decompiling shared objects to C and inspect compiler optimizations

```nix "modules/home/packages/developing/default-packages" +=
ghidra
```

### C sources

1. `File` > `Parse C Source`
2. Create new parse configuration
3. in Parse Options add `-I/home/<USER>/.local/include/ghidra`

```nix "modules/home/packages/developing/default" +=
home.file.".local/include/ghidra".source = pkgs.symlinkJoin {
  name = "ghidra-c-headers";
  paths = [
    "${pkgs.glibc.dev}/include"
    "${pkgs.linuxHeaders}/include"
    "${pkgs.openssl.dev}/include"
    "${pkgs.gcc-unwrapped}/lib/gcc/${pkgs.stdenv.hostPlatform.config}/${pkgs.gcc-unwrapped.version}/include"
  ];
};
```
