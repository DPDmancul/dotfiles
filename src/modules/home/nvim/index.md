# Neovim

```nix modules/home/nvim/default.nix
{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
    ./ui.nix
    ./editing.nix
    ./keymap.nix
    ./lang.nix
    ./lsp.nix
  ];

  programs.neovim = {
    enable = true;
    extraConfig = ''
      <<<modules/home/nvim-config>>>
    '';
    plugins = with pkgs; with vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      <<<modules/home/nvim-plugins>>>
    ];
  };

  appDefaultForMimes."nvim.desktop" = "text/plain";

  <<<modules/home/nvim-main>>>
}
```

Set space as leader

```vim "modules/home/nvim-config" +=
let g:mapleader = ' '
```

Use return to enter command mode: it's easier to press than _:_

```vim "modules/home/nvim-config" +=
nnoremap <cr> :
vnoremap <cr> :
```

## General

```vim "modules/home/nvim-config" +=
set mouse=a     " Enable mouse
set lazyredraw  " Use lazy redraw
set undofile    " Enable persistent undo
set hidden      " Allow buffers in background
```

## Search

```vim "modules/home/nvim-config" +=
set ignorecase " Enable case insensitive search
set smartcase  " when using uppercase make case sensitive
set incsearch  " Show search results while typing
```

### Fuzzy finder

Use telescope as fuzzy finder

```nix "modules/home/nvim-plugins" +=
telescope-file-browser-nvim
telescope-fzf-native-nvim
telescope-symbols-nvim
{
  plugin = telescope-nvim;
  type = "lua";
  config = ''
    <<<modules/home/nvim-telescope>>>
  '';
}
```
```lua "modules/home/nvim-telescope" +=
local telescope = require "telescope"
telescope.load_extension("file_browser")
telescope.load_extension("projects")
telescope.load_extension("fzf")
-- telescope.load_extension("termfinder")
```

## Git

Git easy with ~~Magit~~ Lazygit

```lua "modules/home/nvim/ui-toggleterm" +=
local lazygit = require"toggleterm.terminal".Terminal:new {
  cmd = "lazygit",
  hidden = true,
  count = 0,
  direction = "tab",
  on_open = function(term)
    term.old_laststatus = vim.opt_local.laststatus
    vim.opt_local.laststatus = 0
    vim.opt_local.signcolumn = "no"
    pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<esc>")
  end,
  on_close = function(term)
    vim.opt_local.laststatus = term.old_laststatus
  end
}
function lazygit_toggle()
  lazygit:toggle()
end
vim.api.nvim_create_user_command("Lazygit", lazygit_toggle, {})
```

Use NeoVim remote to open git message edit

```nix "modules/home/nvim-main" +=
home.packages = with pkgs; [
  neovim-remote
];
```

```vim "modules/home/nvim-config" +=
let $GIT_EDITOR = 'nvr -cc split --remote-wait'
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
```

Show git signs

```nix "modules/home/nvim-plugins" +=
{
  plugin = gitsigns-nvim;
  type = "lua";
  config = ''require"gitsigns".setup()'';
}
```

## Spelling

```vim "modules/home/nvim-config" +=
set spell
set spelllang=en,it     " Define spelling dictionaries
set complete+=kspell    " Add spellcheck options for autocomplete
set spelloptions=camel  " Treat parts of camelCase words as separate words
```

## Projects

```nix "modules/home/nvim-plugins" +=
{
  plugin = project-nvim;
  type = "lua";
  config = ''require"project_nvim".setup()'';
}
```

## Mini.nvim

A collection of small useful plugins
```nix "modules/home/nvim-plugins" +=
{
  plugin = mini-nvim;
  type = "lua";
  config = ''
    <<<mini-nvim>>>
  '';
}
```

