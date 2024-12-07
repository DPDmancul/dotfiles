# *TODO* Neovim key mappings

TODO add options

```nix modules/home/nvim/keymap.nix
{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    plugins = with pkgs; with vimPlugins; [
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          local wk = require "which-key"
          <<<modules/home/nvim/keymap-which-key>>>
        '';
      }
    ];
  };
}
```

Declare key bindings

```lua "modules/home/nvim/keymap-which-key" +=
wk.add {
  <<<modules/home/nvim/keymap-keybind>>>
}
```

## Find

```lua "modules/home/nvim/keymap-keybind" +=
{ "<leader>f", group = "Find"},
{ "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume saerch" },
{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
{ "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
{ "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "Explore" },
{ "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "File tree" },
-- { "<leader>f\\", "<cmd>Telescope termfinder find<cr>", desc = "Terminals" },
{ "<leader>f:", "<cmd>Telescope commands<cr>", desc = "Commands" },
{ "<leader>fa", "<cmd>Telescope<cr>", desc = "All telescopes" },
```

## Code

```lua "modules/home/nvim/keymap-keybind" +=
{ "<leader>c", group = "Code" },
{ "<leader>ce", "<cmd>FeMaco<cr>", desc = "Edit fenced block" },
```

## Git

```lua "modules/home/nvim/keymap-keybind" +=
{ "<leader>g" , group = "Git" },
{ "<leader>gg", "<cmd>Lazygit<cr>", desc = "Lazygit" },
```

## Reload

```lua "modules/home/nvim/keymap-keybind" +=
{ "<leader>r", group = "Reload" },
{ "<leader>rr", "<cmd>e<cr>", desc = "File" },
{ "<leader>rc", "<cmd>source ~/.config/nvim/init.vim<cr>", desc = "Config" },
```

## Table

```lua "modules/home/nvim/keymap-keybind" +=
{ "<leader>t", group = "Table" },
{ "<leader>tm", desc = "Toggle table mode" },
{ "<leader>tt", desc = "To table" },
```

## Bufferline

```lua "modules/home/nvim/keymap-keybind" +=
{ "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
{ "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
{ "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
{ "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
{ "gb", "<cmd>BufferLinePick<cr>", desc = "Go to buffer" },
{ "gB", "<cmd>BufferLinePickClose<cr>", desc = "Close picked buffer" },
```

## LSP

```lua "modules/home/nvim/keymap-lsp-keybind" +=
{ "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", desc = "Go to declaration" },
{ "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", desc = "Go to defintion" },
{ "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", desc = "Go to implementation" },
{ "gr", "<cmd>lua vim.lsp.buf.references()<CR>", desc = "References" },
{ "<S-k>", "<cmd>lua vim.lsp.buf.hover()<CR>", desc = "Documentation" },
{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", desc = "Signature help" },
{ "<leader>w", group = "Workspace" },
{ "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", desc = "Add workspace folder" },
{ "<leader>wr:", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", desc = "Remove workspace folder" },
{ "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "List workspace folders" },
{ "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", desc = "Type definition" },
{ "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<CR>", desc = "Rename" },
{ "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", desc = "Code action" },
{ "<leader>cf", "<cmd>lua vim.lsp.buf.format{async=true}<CR>", desc = "Format buffer" },
{ "<leader>cl", "<cmd>lua vim.lsp.codelens.run()<CR>", desc = "Code lens" },
{ "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", desc = "Show line diagnostics" },
{ "<leader>q", "<cmd>lua vim.diagnostic.set_loclist()<CR>", desc = "Set loclist" },
{ "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Go to previous" },
{ "]d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", desc = "Go to next" },
```

