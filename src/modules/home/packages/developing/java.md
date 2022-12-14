# Java

```nix modules/home/packages/developing/java.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    openjdk17
  ];

  <<<modules/home/packages/developing/java>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/java" +=
nvimLSP.jdtls  = {
  package = pkgs.jdt-language-server;
  config.cmd = ["jdt-language-server" "-data" "${config.home.homeDirectory}/.jdt/workspace"];
};
```

