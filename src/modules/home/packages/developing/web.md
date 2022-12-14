# Web development

```nix modules/home/packages/developing/web.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../../nvim/lsp.nix
  ];

  <<<modules/home/packages/developing/web>>>
}
```

## Neovim support

```nix "modules/home/packages/developing/web" +=
nvimLSP = with pkgs; {
  html = rec {
    package = nodePackages.vscode-langservers-extracted;
    config.cmd = ["${package}/bin/vscode-html-language-server" "--stdio"];
  };
  cssls = rec {
    package = nodePackages.vscode-langservers-extracted;
    config.cmd = ["${package}/bin/vscode-css-language-server" "--stdio"];
  };
};
```

