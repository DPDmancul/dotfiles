# Node.js

```nix modules/home/packages/developing/node.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    nodePackages.pnpm
  ];

  home.sessionVariables.PNPM_HOME =
    "${config.home.homeDirectory}/.pnpm-global";
  home.sessionPath = [
    config.home.sessionVariables.PNPM_HOME
  ];

  <<<modules/home/packages/developing/node>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/node" +=
# You must manually install `pnpm i -g eslint`
# and run `pnpx eslint --init` in all projects
nvimLSP.eslint = rec { # JS (EcmaScript) and TS
  package = pkgs.nodePackages.vscode-langservers-extracted;
  config = {
    cmd = ["${package}/bin/vscode-eslint-language-server" "--stdio"];
    settings = { packageManager = "pnpm"; };
  };
};
```
