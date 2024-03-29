# Neovim UI

```nix modules/home/nvim/ui.nix
{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraConfig = ''
      <<<modules/home/nvim/ui-config>>>
    '';
    plugins = with pkgs; with vimPlugins; [
      <<<modules/home/nvim/ui-plugins>>>
    ];
  };

}
```
```vim "modules/home/nvim/ui-config" +=
set termguicolors     " Enable gui colors
set cursorline        " Enable highlighting of the current line
set signcolumn=yes    " Always show signcolumn or it would frequently shift
set pumheight=10      " Make popup menu smaller
set cmdheight=0       " Automatically hide command line
set colorcolumn=+1    " Draw colored column one step to the right of desired maximum width
set linebreak         " Wrap long lines at 'breakat' (if 'wrap' is set)
set scrolloff=2       " Show more lines on top and bottom
set title             " Enable window title
set list              " Show tabs and trailing spaces
```

## Line numbers

Enable relative line numbers

```vim "modules/home/nvim/ui-config" +=
set number          " Show line numbers
set relativenumber  " Show relative line numbers
set numberwidth=1   " Minimum number width
```

Show relative numbers only when needed

```nix "modules/home/nvim/ui-plugins" +=
vim-numbertoggle
```

## Indentation

Show indentation level guide

```lua "mini-nvim" +=
require"mini.indentscope".setup()
```

## *TODO* Conceal

Use conceal to show pretty symbols 

```vim "modules/home/nvim/ui-config" +=
set conceallevel=2
```

## Theme

Use Gruvbox light theme 

```nix "modules/home/nvim/ui-plugins" +=
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

```nix "modules/home/nvim/ui-plugins" +=
lualine-lsp-progress
{
  plugin = lualine-nvim;
  type = "lua";
  config = ''
    <<<modules/home/nvim/ui-lualine>>>
  '';
}
```
```lua "modules/home/nvim/ui-lualine" +=
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

```vim "modules/home/nvim/ui-config" +=
set noshowmode
```

## Bufferline

 View buffers as modern "tabs"

```nix "modules/home/nvim/ui-plugins" +=
{
  plugin = bufferline-nvim;
  type = "lua";
  config = ''
    <<<modules/home/nvim/ui-bufferline>>>
  '';
}
```

```lua "modules/home/nvim/ui-bufferline" +=
require"bufferline".setup {
  options = {
    right_mouse_command = "vertical sbuffer %d",
    middle_mouse_command = "Bdelete! %d",
    close_command = "Bdelete! %d",
    show_close_icon = false,
    custom_filter = function(buf, buf_nums)
      -- Hide quickfix lists from bufferline
      return vim.bo[buf].buftype ~= "quickfix"
    end,
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

```nix "modules/home/nvim/ui-plugins" +=
{
  plugin = wilder-nvim;
  config = "call wilder#setup({'modes': [':', '/', '?']})";
}
```

## Toggle terminal

```nix "modules/home/nvim/ui-plugins" +=
{
  plugin = toggleterm-nvim;
  type = "lua";
  config = ''
    <<<modules/home/nvim/ui-toggleterm>>>
  '';
}
```
```lua "modules/home/nvim/ui-toggleterm" +=
require"toggleterm".setup {
  open_mapping = [[<c-\>]],
  shade_terminals = false
}

function _G.set_terminal_keymaps ()
  for from,to in pairs {
    ["<esc>"] = [[<C-\><C-n>]],
    ["<C-w><C-w>"] = [[<cmd>wincmd w<cr>]],
    ["<C-w>w"] = [[<cmd>wincmd w<cr>]],
    ["<C-w>h"] = [[<cmd>wincmd h<cr>]],
    ["<C-w>j"] = [[<cmd>wincmd j<cr>]],
    ["<C-w>k"] = [[<cmd>wincmd k<cr>]],
    ["<C-w>l"] = [[<cmd>wincmd l<cr>]],
  } do
    vim.api.nvim_buf_set_keymap(0, "t", from, to, {
      noremap = true,
      silent = true
    })
  end
end

vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
```

## Sticky buffers and windows

Do not permit normal buffers to open in terminal, filetree, ... windows

```nix "modules/home/nvim/ui-plugins" +=
{
  plugin = (vimUtils.buildVimPlugin {
    name = "stickybuf-nvim";
    src = fetchFromGitHub {
      owner = "stevearc";
      repo = "stickybuf.nvim";
      rev = "db2965ccd97b3f1012b19a76d8541f9843b12960";
      sha256 = "J/j7pyvqdSfQUkcXw0krvw303N+FlgDN+wH0bAefOYw=";
    };
  });
  type = "lua";
  config = ''
    require("stickybuf").setup({
      buftype = {
        quickfix = "buftype", -- VimTeX
      },
      filetype = {
        toggleterm = "filetype",
      }
    })
  '';
}
```

Do not alter window disposition on buffer close

```lua "mini-nvim" +=
require"mini.bufremove".setup()
vim.api.nvim_create_user_command('Bdelete', function(args)
  MiniBufremove.delete(tonumber(args.args), args.bang)
end, { bang = true, addr = 'buffers', nargs = '?' })
vim.api.nvim_set_keymap('c', 'bd', 'Bdelete', {noremap = true})
```

## Smooth scroll

```nix "modules/home/nvim/ui-plugins" +=
{
  plugin = neoscroll-nvim;
  type = "lua";
  config = ''require"neoscroll".setup{}'';
}
```

