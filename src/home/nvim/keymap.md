# *TODO* Neovim key mappings

```nix "nvim-plugins" +=
{
  plugin = which-key-nvim;
  type = "fennel";
  config = ''
    (let [wk (require :which-key)]
      <<<nvim-which-key>>>
      )
  '';
}
```

Setup which-key window

```lisp "nvim-which-key" +=
(wk.setup
  {:spelling {:enabled true
              :suggestions 10}
   :window {:margin [0 0 0 0]
            :padding [1 0 1 0]}})
```

Declare key bindings

```lisp "nvim-which-key" +=
(let [map (fn [from to ...]
            {1 from
             2 to
             ...
             :noremap true
             :silent true})]
  (wk.register {
      <<<nvim-keybind>>>
    }
    {:prefix "<leader>"}))
```

## Find

```lisp "nvim-keybind" +=
:f {:name "Find"
    :r (map "<cmd>Telescope resume<cr>" "Resume saerch")
    :f (map "<cmd>Telescope find_files<cr>" "Files")
    :g (map "<cmd>Telescope live_grep<cr>" "Grep")
    :b (map "<cmd>Telescope buffers<cr>" "Buffers")
    :h (map "<cmd>Telescope help_tags<cr>" "Help")
    :p (map "<cmd>Telescope projects<cr>" "Projects")
    :s (map (. (require :session-lens) :search_session) "Sessions")
    :e (map "<cmd>Telescope file_browser<cr>" "Explore")
    :t (map "<cmd>NvimTreeToggle<cr>" "File tree")
    :\ (map "<cmd>Telescope termfinder find<cr>" "Terminals")
    :: (map "<cmd>Telescope commands<cr>" "Commands")
    :a (map "<cmd>Telescope<cr>" "All telescopes")}
```

## Git

```lisp "nvim-keybind" +=
:g {:name "Git"
    :g (map "<cmd>Neogit<cr>" "Neo git")}
```

## Reload

```lisp "nvim-keybind" +=
:r {:name "Reload"
    :r (map "<cmd>e<cr>" "File")
    :c (map "<cmd>source ~/.config/nvim/init.lua<cr>", "Config")}
```

## Table

```lisp "nvim-keybind" +=
:t {:name "Table"
    :m "Toggle table mode"
    :t "To table"}
```

## LSP

```lisp "nvim-lsp-keybind" +=
:g {:D (map "<cmd>lua vim.lsp.buf.declaration()<CR>" "Go to declaration")
    :d (map "<cmd>lua vim.lsp.buf.definition()<CR>" "Go to defintion")
    :i (map "<cmd>lua vim.lsp.buf.implementation()<CR>" "Go to implementation")
    :r (map "<cmd>lua vim.lsp.buf.references()<CR>" "References")}
:k (map "<cmd>lua vim.lsp.buf.hover()<CR>" "Documentation")
:<C-k> (map "<cmd>lua vim.lsp.buf.signature_help()<CR>" "Signature help")
:<leader> {:w {:name "Workspace"
               :a (map "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>" "Add workspace folder")
               :r (map "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>" "Remove workspace folder")
               :l (map "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>" "List workspace folders")}
           :D (map "<cmd>lua vim.lsp.buf.type_definition()<CR>" "Type definition")
           :rn (map "<cmd>lua vim.lsp.buf.rename()<CR>" "Rename")
           :c {:name "Code"
               :a (map "<cmd>lua vim.lsp.buf.code_action()<CR>" "Code action")
               :f (map "<cmd>lua vim.lsp.buf.formatting()<CR>" "Format buffer")}
           :e (map "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>" "Show line diagnostics")
           :q (map "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>" "Set loclist")}
"[d" (map "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" "Go to previous")
"]d" (map "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>" "Go to next")
```

