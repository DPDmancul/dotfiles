# Node.js

```nix modules/home/packages/developing/node.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    nodejs
  ];

  home.sessionVariables.PREFIX =
    "${config.home.homeDirectory}/.npm-global";
  home.sessionPath = [
    config.home.sessionVariables.PREFIX
  ];

  <<<modules/home/packages/developing/node>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/node" +=
# You must manually install `npm i -g eslint`
# and run `npx eslint --init` in all projects
nvimLSP.eslint = rec { # JS (EcmaScript) and TS
  package = pkgs.nodePackages.vscode-langservers-extracted;
  config = {
    cmd = ["${package}/bin/vscode-eslint-language-server" "--stdio"];
  };
};
```

