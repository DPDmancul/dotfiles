# Neovim editing

```nix modules/home/nvim/editing.nix
{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraConfig = ''
      <<<modules/home/nvim/editing-config>>>
    '';
    plugins = with pkgs; with vimPlugins; [
      <<<modules/home/nvim/editing-plugins>>>
    ];
  };

}
```
```vim "modules/home/nvim/editing-config" +=
set whichwrap=b,s,h,l,<,>,[,] " Allow moving along lines when the start/end is reached
set clipboard=unnamedplus     " Sync yank register with system clipboard
```

## Indentation

1. Use `editorconfig` to set indentation
1. If not, try detect used indentation with `sleuth`
1. Fallback to two spaces

```nix "modules/home/nvim/editing-plugins" +=
editorconfig-nvim
vim-sleuth
```

```vim "modules/home/nvim/editing-config" +=
set expandtab     " Convert tabs to spaces
set tabstop=2     " Display 2 spaces for a tab
set shiftwidth=2  " Use this number of spaces for indentation
set smartindent   " Make indenting smart
set autoindent    " Use auto indent
set breakindent   " Indent wrapped lines to match line start
```

## Motion

Allow going past the end of line in visual block mode 

```vim "modules/home/nvim/editing-config" +=
set virtualedit=block
```

### Case motion

Move into CamelCase and snake\_case words 

```nix "modules/home/nvim/editing-plugins" +=
{
  plugin = camelcasemotion;
  config = "let g:camelcasemotion_key = '\\'";
}
```

### Around and inner text objects

```lua "modules/home/nvim/editing-nvim" +=
require"mini.ai".setup()
```

### Goto char across lines

Use `f` and `t` across lines

```nix "modules/home/nvim/editing-plugins" +=
(vimUtils.buildVimPlugin {
  name = "vim-fanfingtastic";
  src = fetchFromGitHub {
    owner = "dahu";
    repo = "vim-fanfingtastic";
    rev = "6d0fea6dafbf3383dbab1463dbfb3b3d1b94b209";
    sha256 = "wmiKxuNjazkOWFcuMvDJzdPp2HhDu8CNL0rxu+8hrKs=";
  };
})
```

## Comments

```lua "modules/home/nvim/editing-nvim" +=
require"mini.comment".setup()
```

## Edit with sudo

```nix "modules/home/nvim/editing-plugins" +=
{
  plugin = suda-vim;
  config = "let g:suda_smart_edit = 1";
}
```

## Parenthesis, quotes & co.

Autoclose parenthesis and quotes 

```nix "modules/home/nvim/editing-plugins" +=
{
  plugin = nvim-autopairs;
  type = "lua";
  config = ''
    require"nvim-autopairs".setup{}
  '';
}
```

Easy add, remove and change parenthesis and quotes 

```nix "modules/home/nvim/editing-plugins" +=
{
  plugin = nvim-surround;
  type = "lua";
  config = ''
    require"nvim-surround".setup{}
  '';
}
```

## Table edit

```nix "modules/home/nvim/editing-plugins" +=
vim-table-mode
```

## Syntax highlighting

Do syntax highlighting via treesitter

```nix "modules/home/nvim/editing-plugins" +=
nvim-ts-rainbow
{
  plugin = nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars);
  type = "lua";
  config = ''
    <<<modules/home/nvim/editing-treesitter>>>
  '';
}
```

Enable all maintained languages, except LaTeX (highlighted and concealed via VimTeX)

```lua "modules/home/nvim/editing-treesitter" +=
require"nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
    disable = { "latex" },
  },
  incremental_selection = { enable = true },
  indentation = { enable = true },
  folding = { enable = true },
  -- rainbow parenthesis match
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters
    max_file_lines = nil
  }
}
```

Show color of colors

```nix "modules/home/nvim/editing-plugins" +=
{
  plugin = nvim-colorizer-lua;
  type = "lua";
  config = ''require"colorizer".setup{}'';
}
```

### Edit inside Markdown

Open temporary buffer to edit code in Markdown

```nix "modules/home/nvim/editing-plugins" +=
{
  plugin = nur.repos.m15a.vimExtraPlugins.nvim-FeMaco-lua;
  type = "lua";
  config = ''require"femaco".setup()'';
}
```

## Undo tree

Better undo exploring the tree of all changes

```nix "modules/home/nvim/editing-plugins" +=
undotree
```

Add keymap

```lua "modules/home/nvim/keymap-keybind-leader" +=
u = map ("<cmd>UndotreeToggle<cr>", "Undo tree"),
```

## *TODO* Format

### List formatting

 Define pattern for a start of numbered list. This is responsible for correct
 formatting of lists inside comments when using `gq`. This basically reads as
 one of: 

 1. space + character + `.` or `)` + space;
 1. space + `-` or `+` or `*` + space.

Source: <https://stackoverflow.com/a/37172060>

```vim "modules/home/nvim/editing-config" +=
set formatlistpat=^\\s*\\w\\+[.\)]\\s\\+\\\\|^\\s*[\\-\\+\\*]\\+\\s\\+
```

### Folds

```vim "modules/home/nvim/editing-config" +=
set foldmethod=indent  " Set 'indent' folding method
set nofoldenable       " Start with folds opened
```

## IPA input

Allow easy writing in international phonetics alphabet

```nix "modules/home/nvim/editing-plugins" +=
(vimUtils.buildVimPlugin rec {
  name = "vim-xsampa";
  src = fetchFromGitHub {
    owner = "DPDmancul";
    repo = name;
    rev = "2a7ccb69c508e49126b541625e990b03a90e262f";
    sha256 = "te8pq/TxDepG/Lz4+rxfDa32K0sSWCFLcxlR3H79Wdg=";
  };
})
```
