# Neovim

```nix "home-config" +=
programs.neovim = let
  lsp_servers = {
    <<<lsp-servers>>>
  };
  let
    value_to_fennel = value:
      if builtins.isAttrs value then
        set_to_fennel value
      else if builtins.isList value then
        list_to_fennel value
      else
        ''"${value}"'';
    list_to_fennel = list: "[${builtins.toString
      (builtins.map value_to_fennel list)}]";
    set_to_fennel = set: "{" +
      builtins.toString (builtins.attrValues (builtins.mapAttrs
        (name: value: ''"${name}" ${value_to_fennel value}'') set
      )) + "}";
  in lsp_servers_config = set_to_fennel (builtins.mapAttrs
    (_: x: x.config or {}) lsp_servers);
in {
  enable = false; # TODO enable
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
telescope-termfinder
{
  plugin = telescope-nvim;
  type = "fennel";
  config = ''
    <<<telescope-config>>>
  '';
}
```
```lisp "telescope-config" +=
(let [telescope (require :telescope)]
  (each [_ ext (ipairs ["file_browser"
                        "projects"
                        "fzf"
                        "termfinder"])]
    (telescope.load_extension ext)))
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
  config = ''require"gitsigns".setup()'');
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
  config = ''require"project_nvim".setup()'');
}
```



