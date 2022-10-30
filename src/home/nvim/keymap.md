# *TODO* Neovim key mappings

```nix "nvim-plugins" +=
{
  plugin = which-key-nvim;
  type = "lua";
  config = ''
    local wk = require "which-key"
    <<<nvim-which-key>>>
  '';
}
```

Setup which-key window

```lua "nvim-which-key" +=
wk.setup {
  spelling = {
    enabled = true,
    suggestions = 10
  },
  window = {
    margin = {0, 0, 0, 0},
    padding = {1, 0, 1, 0,}
  }
}
```

Declare key bindings

```lua "nvim-which-key" +=
local map = function (from, to, ...)
  return {
    from, to, ...,
    noremap = true,
    silent = true
  }
end
wk.register ( 
  {
    <<<nvim-keybind-leader>>>
  },
  { prefix = "<leader>" }
)
wk.register {
  <<<nvim-keybind>>>
}
```

## Find

```lua "nvim-keybind-leader" +=
f = {
  name = "Find",
  r = map ("<cmd>Telescope resume<cr>", "Resume saerch"),
  f = map ("<cmd>Telescope find_files<cr>", "Files"),
  g = map ("<cmd>Telescope live_grep<cr>", "Grep"),
  b = map ("<cmd>Telescope buffers<cr>", "Buffers"),
  h = map ("<cmd>Telescope help_tags<cr>", "Help"),
  p = map ("<cmd>Telescope projects<cr>", "Projects"),
  e = map ("<cmd>Telescope file_browser<cr>", "Explore"),
  t = map ("<cmd>NvimTreeToggle<cr>", "File tree"),
  -- ["\\"] = map ("<cmd>Telescope termfinder find<cr>", "Terminals"),
  [":"] = map ("<cmd>Telescope commands<cr>", "Commands"),
  a = map ("<cmd>Telescope<cr>", "All telescopes"),
},
```

## Git

```lua "nvim-keybind-leader" +=
g = {
  name = "Git",
  g = map ("<cmd>Lazygit<cr>", "Lazygit"),
},
```

## Reload

```lua "nvim-keybind-leader" +=
r = {
  name = "Reload",
  r = map ("<cmd>e<cr>", "File"),
  c = map ("<cmd>source ~/.config/nvim/init.vim<cr>", "Config"),
},
```

## Table

```lua "nvim-keybind-leader" +=
t = {
  name = "Table",
  m = "Toggle table mode",
  t = "To table"
},
```

## Bufferline

```lua "nvim-keybind" +=
["]b"] = map ("<cmd>BufferLineCycleNext<cr>", "Next buffer"),
["]B"] = map ("<cmd>BufferLineMoveNext<cr>", "Move buffer right"),
["[b"] = map ("<cmd>BufferLineCyclePrev<cr>", "Previous buffer"),
["[B"] = map ("<cmd>BufferLineMovePrev<cr>", "Move buffer left"),
gb = map ("<cmd>BufferLinePick<cr>", "Go to buffer"),
gB = map ("<cmd>BufferLinePickClose<cr>", "Close picked buffer"),
```

## LSP

```lua "nvim-lsp-keybind" +=
g = {
  D = map ("<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration"),
  d = map ("<cmd>lua vim.lsp.buf.definition()<CR>", "Go to defintion"),
  i = map ("<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation"),
  r = map ("<cmd>lua vim.lsp.buf.references()<CR>", "References")
},
["<S-k>"] = map ("<cmd>lua vim.lsp.buf.hover()<CR>", "Documentation"),
["<C-k>"] = map ("<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help"),
["<leader>"] = {
  w = {
    name = "Workspace",
    a = map ("<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace folder"),
    r = map ("<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove workspace folder"),
    l = map ("<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List workspace folders")
  },
  D = map ("<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type definition"),
  r = map ("<cmd>lua vim.lsp.buf.rename()<CR>", "Rename"),
  c = {
    name = "Code",
    a = map ("<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action"),
    f = map ("<cmd>lua vim.lsp.buf.format{async=true}<CR>", "Format buffer")
  },
  e = map ("<cmd>lua vim.diagnostic.open_float()<CR>", "Show line diagnostics"),
  q = map ("<cmd>lua vim.diagnostic.set_loclist()<CR>", "Set loclist")
},
["[d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous"),
["]d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to next"),
```

