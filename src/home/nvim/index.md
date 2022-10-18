# Neovim

```nix "home-config" +=
programs.neovim = let
  lsp_servers = with pkgs; {
    <<<lsp-servers>>>
  };
  lsp_servers_config = let
    value_to_lua = value:
      if builtins.isAttrs value then
        set_to_lua value
      else if builtins.isList value then
        list_to_lua value
      else
        ''"${value}"'';
    list_to_lua = list: "{" + builtins.toString
      (builtins.map (e: value_to_lua e + ", ") list) + "}";
    set_to_lua = set: "{" +
      builtins.toString (builtins.attrValues (builtins.mapAttrs
        (name: value: ''["${name}"] = ${value_to_lua value},'') set
      )) + "}";
  in set_to_lua (builtins.mapAttrs
    (_: x: x.config or {}) lsp_servers);
in {
  enable = true;
  extraConfig = ''
    <<<nvim-config>>>
  '';
  extraPackages = builtins.map (x: x.package or x)
    (builtins.attrValues lsp_servers);
  plugins = with pkgs.vimPlugins; let
    inherit (pkgs.vimUtils) buildVimPlugin;
  in [
    plenary-nvim
    nvim-web-devicons
    <<<nvim-plugins>>>
  ];
};
```

Set space as leader

```vim "nvim-config" +=
let g:mapleader = ' '
```

Use return to enter command mode: it's easier to press than _:_

```vim "nvim-config" +=
nnoremap <cr> :
vnoremap <cr> :
```

## General

```vim "nvim-config" +=
set mouse=a     " Enable mouse
set lazyredraw  " Use lazy redraw
set undofile    " Enable persistent undo
set hidden      " Allow buffers in background
```

## Search

```vim "nvim-config" +=
set ignorecase " Enable case insensitive search
set smartcase  " when using uppercase make case sensitive
set incsearch  " Show search results while typing
```

### Fuzzy finder

Use telescope as fuzzy finder

```nix "nvim-plugins" +=
telescope-file-browser-nvim
telescope-fzf-native-nvim
telescope-symbols-nvim
# telescope-termfinder
{
  plugin = telescope-nvim;
  type = "lua";
  config = ''
    <<<telescope-config>>>
  '';
}
```
```lua "telescope-config" +=
local telescope = require "telescope"
telescope.load_extension("file_browser")
telescope.load_extension("projects")
telescope.load_extension("fzf")
-- telescope.load_extension("termfinder")
```

## Git

Git easy with ~~Magit~~ Neogit

```nix "nvim-plugins" +=
diffview-nvim
{
  plugin = neogit;
  type = "lua";
  config = ''
    <<<neogit-config>>>
  '';
}
```
```lua "neogit-config" +=
require"neogit".setup{
  integrations = {
    diffview = true
  }
}
```

Show git signs

```nix "nvim-plugins" +=
{
  plugin = gitsigns-nvim;
  type = "lua";
  config = ''require"gitsigns".setup()'';
}
```

## Spelling

```vim "nvim-config" +=
set spell
set spelllang=en,it     " Define spelling dictionaries
set complete+=kspell    " Add spellcheck options for autocomplete
set spelloptions=camel  " Treat parts of camelCase words as separate words
```

## Projects

```nix "nvim-plugins" +=
{
  plugin = project-nvim;
  type = "lua";
  config = ''require"project_nvim".setup()'';
}
```

## Mini.nvim

A collection of small useful plugins
```nix "nvim-plugins" +=
{
  plugin = mini-nvim;
  type = "lua";
  config = ''
    <<<mini-nvim>>>
  '';
}
```

