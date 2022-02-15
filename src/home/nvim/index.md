# Neovim

```nix "home-config" +=
programs.neovim = {
  enable = false; # TODO enable
  extraConfig = ''
    <<<nvim-config>>>
  '';
  plugins = with pkgs.vimPlugins; [
    <<<nvim-plugins>>>
  ];
};
```

Set space as leader

```vim "nvim-config" +=
let mapleader = " "
```

## General

```vim "nvim-config" +=
set mouse=a     " Enable mouse
set lazyredraw  " Use lazy redraw
set undofile    " Enable persistent undo
set hidden      " Allow buffers in background
```

