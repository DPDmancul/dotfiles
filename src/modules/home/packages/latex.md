# LaTeX

```nix modules/home/packages/latex.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../nvim/lsp.nix
  ];

  home.packages = with pkgs; [
    texlive.combined.scheme-full
    python3Packages.pygments
    textidote
  ];
  <<<modules/home/packages/latex>>>
}
```

## Neovim support

Use LaTeX instead of plain TeX

```nix "modules/home/packages/latex" +=
programs.neovim.extraConfig = ''
  let g:tex_flavor = 'latex'
'';

nvimLSP.texlab = pkgs.texlab;
```

### VimTeX

```nix "modules/home/packages/latex" +=
programs.neovim.plugins = with pkgs.vimPlugins; [
  {
    plugin = vimtex;
    config = ''
      let g:vimtex_view_general_viewer =  'okular'
    '';
    type = "viml";
  }
];
```

