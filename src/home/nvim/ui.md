# Neovim UI

```vim "nvim-config" +=
set termguicolors     " Enable gui colors
set cursorline        " Enable highlighting of the current line
set signcolumn=yes  " Always show signcolumn or it would frequently shift
set pumheight=10      " Make popup menu smaller
set colorcolumn=+1  " Draw colored column one step to the right of desired maximum width
set linebreak         " Wrap long lines at 'breakat' (if 'wrap' is set)
set scrolloff=2       " Show more lines on top and bottom
set title             " Enable window title
set list              " Show tabs and trailing spaces
```

## Line numbers

Enable relative line numbers

```vim "nvim-config" +=
set number          " Show line numbers
set relativenumber  " Show relative line numbers
set numberwidth=1   " Minimum number width
```

Show relative numbers only when needed

```nix "nvim-plugins" +=
vim-numbertoggle
```

## *TODO* Conceal

Use conceal to show pretty symbols 

```vim "nvim-config" +=
set conceallevel=2
```

## Theme

Use Gruvbox light theme 

```nix "nvim-plugins" +=
lush-nvim
{
  plugin = gruvbox-nvim;
  config = ''
    set background=light
    colorscheme gruvbox
  '';
}
```

## Statusline

Use lualine as statusline, adding `lsp_progres`s and an indication on the
indentation size and type.

```nix "nvim-plugins" +=
lualine-lsp-progress
{
  plugin = lualine-nvim;
  type = "lua";
  config = ''
    <<<lualine-config>>>
  '';
}
```
```lua "lualine-config" +=
require"lualine".setup {
  options = {
    section_separators = {
      left = "",
      right = ""
    },
    component_separators = {
       left = "|",
       right = "|"
    },
  },
  sections = {
    lualine_c = {
      "filename",
      "lsp_progress"
    },
    lualine_x = {
      "encoding",
      "fileformat",
      function ()
        if vim.o.expandtab then
          return vim.o.shiftwidth .. " ␣"
        else
          return vim.o.tabstop .. " ↹"
        end
      end,
      "filetype"
    }
  }
}
```

Hide mode: it is already visible in lualine 

```vim "nvim-config" +=
set noshowmode
```

## Bufferline

 View buffers as modern "tabs"

```nix "nvim-plugins" +=
{
  plugin = bufferline-nvim;
  type = "lua";
  config = ''
    <<<bufferline-config>>>
  '';
}
```
```lua "bufferline-config" +=
require"bufferline".setup {
  options = {
    right_mouse_command = nil,
    middle_mouse_command = "bdelete! %d",
    show_close_icon = false,
    offsets = {
      {
        filetype = "NvimTree",
        text = vim.fn.getcwd
      }
    }
  }
}
```

## Command and search completion

```nix "nvim-plugins" +=
{
  plugin = wilder-nvim;
  config = "call wilder#setup({'modes': [':', '/', '?']})";
}
```

## Toggle terminal

```nix "nvim-plugins" +=
{
  plugin = toggleterm-nvim;
  type = "lua";
  config = ''
    <<<toggleterm-config>>>
  '';
}
```
```lua "toggleterm-config" +=
require"toggleterm".setup {
  open_mapping = [[<c-\>]],
  shade_terminals = false
}

function _G.set_terminal_keymaps ()
  for from,to in pairs {
    ["<esc>"] = [[<C-\><C-n>]],
    ["<C-w>"] = [[<C-\><C-n><C-W>]],
    ["<C-h>"] = [[<C-\><C-n><C-W>h]],
    ["<C-j>"] = [[<C-\><C-n><C-W>j]],
    ["<C-k>"] = [[<C-\><C-n><C-W>k]],
    ["<C-l>"] = [[<C-\><C-n><C-W>l]]
  } do
    vim.api.nvim_buf_set_keymap(0, "t", from, to, {
      noremap = true,
      silent = true
    })
  end
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
```

## Smooth scroll

```nix "nvim-plugins" +=
{
  plugin = neoscroll-nvim;
  type = "lua";
  config = ''require"neoscroll".setup{}'';
}
```

