# Agda

```nix modules/home/packages/developing/agda.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    (agda.withPackages (p: [ p.standard-library ]))
  ];
  <<<modules/home/packages/developing/agda>>>
}
```

### Neovim support

```nix "modules/home/packages/developing/agda" +=
programs.neovim.plugins = with pkgs; [
  {
    plugin = (vimUtils.buildVimPlugin {
      name = "agda-nvim";
      src = fetchFromGitHub {
        owner = "Isti115";
        repo = "agda.nvim";
        rev = "c7da627547e978b4ac3780af1b8f418c8b12ff98";
        sha256 = "c7UjrVbfaagIJS7iGdjWiFlpLUDHGc0I3ZGoUPECL00=";
      };
    });
    config = ''
      let g:agda_theme = "light"
      function! AgdaMapping()
        noremap <silent> <buffer> <LocalLeader>L :lua require('agda').load()<cr> " To not clash with VimTeX
      endfunction
      autocmd BufWinEnter *.agda call AgdaMapping()
      autocmd BufWinEnter *.lagda* call AgdaMapping()
      digr ZZ 8484
      digr NN 8469
      digr RR 8477
      digr FF 120125
    '';
  }
  {
    plugin = (vimUtils.buildVimPlugin rec {
      name = "vim-agda";
      src = fetchFromGitHub {
        owner = "msuperdock";
        repo = name;
        rev = "1695060850b5991e8aded0861fae0c31877950a7";
        sha256 = "xp/aeki1f0DqyOjv8Yw+KUfPOeRRJDW86vgw0YcOIlc=";
      };
    });
  }
];
```

