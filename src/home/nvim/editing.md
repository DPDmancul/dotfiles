# Neovim editing

```vim "nvim-config" +=
set whichwrap=b,s,h,l,<,>,[,] " Allow moving along lines when the start/end is reached
set clipboard=unnamedplus     " Sync yank register with system clipboard
```

## Indentation

1. Use `editorconfig` to set indentation
1. If not, try detect used indentation with `sleuth`
1. Fallback to two spaces

```nix "nvim-plugins" +=
editorconfig-nvim
vim-sleuth
```

```vim "nvim-config" +=
set expandtab     " Convert tabs to spaces
set tabstop=2     " Display 2 spaces for a tab
set shiftwidth=2  " Use this number of spaces for indentation
set smartindent   " Make indenting smart
set autoindent    " Use auto indent
set breakindent   " Indent wrapped lines to match line start
```

## Motion

Allow going past the end of line in visual block mode 

```vim "nvim-config" +=
set virtualedit=block
```

### Case motion

Move into CamelCase and snake\_case words 

```nix "nvim-plugins" +=
{
  plugin = camelcasemotion;
  config = "let g:camelcasemotion_key = '\\'";
}
```

### Goto char across lines

Use `f` and `t` across lines

```nix "nvim-plugins" +=
(buildVimPlugin {
  name = "vim-fanfingtastic";
  src = pkgs.fetchFromGitHub {
    owner = "dahu";
    repo = "vim-fanfingtastic";
    rev = "6d0fea6dafbf3383dbab1463dbfb3b3d1b94b209";
    sha256 = "sha256-wmiKxuNjazkOWFcuMvDJzdPp2HhDu8CNL0rxu+8hrKs=";
  };
})
```

## Comments

```nix "nvim-plugins" +=
kommentary
```

## Edit with sudo

```nix "nvim-plugins" +=
{
  plugin = suda-vim;
  config = "let g:suda_smart_edit = 1";
}
```

## Parenthesis, quotes & co.

Autoclose parenthesis and quotes 

```nix "nvim-plugins" +=
{
  plugin = nvim-autopairs;
  type = "lua";
  config = ''require"nvim-autopairs".setup{}'';
}
```

Easy add, remove and change parenthesis and quotes 

```nix "nvim-plugins" +=
{
  plugin = surround-nvim;
  type = "lua";
  config = ''require"surround".setup{ mappings_style = "sandwich" }'';
}
```

## Table edit

```nix "nvim-plugins" +=
vim-table-mode
```

## Syntax highlighting

Do syntax highlighting via treesitter

```nix "nvim-plugins" +=
nvim-ts-rainbow
{
  plugin = nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars);
  type = "lua";
  config = ''
    <<<treesitter-config>>>
  '';
}
```

Enable all maintained languages

```lua "treesitter-config" +=
require"nvim-treesitter.configs".setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true
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

```nix "nvim-plugins" +=
{
  plugin = nvim-colorizer-lua;
  type = "lua";
  config = ''require"colorizer".setup{}'';
}
```

Nix expression language highlighting 

```nix "nvim-plugins" +=
vim-nix
```

## *TODO* Format

### List formatting

 Define pattern for a start of numbered list. This is responsible for correct
 formatting of lists inside comments when using `gq`. This basically reads as
 one of: 

 1. space + character + `.` or `)` + space;
 1. space + `-` or `+` or `*` + space.

Source: <https://stackoverflow.com/a/37172060>

```vim "nvim-config" +=
set formatlistpat=^\\s*\\w\\+[.\)]\\s\\+\\\\|^\\s*[\\-\\+\\*]\\+\\s\\+
```

### Folds

```vim "nvim-config" +=
set foldmethod=indent  " Set 'indent' folding method
set nofoldenable       " Start with folds opened
```

