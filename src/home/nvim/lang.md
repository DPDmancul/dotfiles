# Neovim language support

Add support for some languages

## LaTeX

Use LaTeX instead of plain TeX

```vim "nvim-config" +=
let g:tex_flavor = 'latex'
```

### VimTeX

```nix "nvim-plugins" +=
{
  plugin = vimtex;
  config = "let g:vimtex_view_general_viewer =  'okular'";
}
```

## *TODO* LSP

Use the power of Language Server Protocol for a better developing experience

### Symbols outline

```nix "nvim-plugins" +=
symbols-outline-nvim
```

### LSP UI

```nix "nvim-plugins" +=
{
  plugin = lspsaga-nvim;
  type = "lua";
  config = ''require"lspsaga".init_lsp_saga()'';
}
```

### Config LSP and completion

```nix "nvim-plugins" +=
nvim-cmp
cmp-nvim-lsp
cmp_luasnip
luasnip
rust-tools-nvim
{
  plugin = nvim-lspconfig;
  type = "fennel";
  config = ''
    <<<lsp-config>>>
  '';
}
```

Set completeopt to have a better completion experience

```vim "nvim-config" +=
set completeopt=menuone,noselect
```

Install LSP servers

```nix "home-packages" +=
rust-analyzer
texlab
nodePackages.bash-language-server
ccls
nodePackages.pyright
deno
nodePackages.yaml-language-server
nodePackages.vscode-css-languageserver-bin
nodePackages.vscode-html-languageserver-bin
nodePackages.vscode-json-languageserver
```

Enable some language servers with the additional completion capabilities
offered by nvim-cmp

```lisp "lsp-config" +=
(let [nvim_lsp (require :lspconfig)
      capabilities (. (require :cmp_nvim_lsp)
                      :update_capabilities
                      (vim.lsp.protocol.make_client_capabilities))
      on_attach (fn [client bufnr]
                  (let [wk (require :which-key)
                        map (fn [from to ...]
                              {1 from
                               2 to
                               ...
                               :buffer bufnr
                               :noremap true
                               :silent true})]
                   (wk.register {
                     <<<nvim-lsp-keybind>>>
                     })))
      servers {:rust-tools {:settings {:rust-analyzer
                                        {:checkOnSave {:command "clippy"}}}}
               :texlab {}
               :bashls {}
               :ccls {}
               :pyright {}
               :html {:cmd ["html-languageserver" "--stdio"]}
               :cssls {:cmd ["css-languageserver" "--stdio"]}
               :denols {} ; JS and TS
               :jsonls {:cmd ["vscode-json-languageserver" "--stdio"]}
               :yamlls {}
               }]
  (each [lsp opt (pairs servers)]
    (tset opt :on_attach on_attach)
    (tset opt :capabilities capabilities)
    ((. nvim_lsp lsp :setup) opt))
```

nvim-cmp setup

```lisp "lsp-config" +=
(let [cmp (require :cmp)
      luasnip (require :luasnip)]
  (cmp.setup 
    {:snippet {:expand (fn [args]
                        (luasnip.lsp_expand args.body))}
     :mapping {:<C-p> (cmp.mapping.select_prev_item)
               :<C-n> (cmp.mapping.select_next_item)
               :<C-u> (cmp.mapping.scroll_docs -4)
               :<C-d> (cmp.mapping.scroll_docs 4)
               :<C-Space> (cmp.mapping.complete)
               :<C-e> (cmp.mapping.close)
               :<CR> (cmp.mapping.confirm
                      {:behavior cmp.ConfirmBehavior.Replace
                       :select true})
               :<Tab> (fn [fallback]
                        (if (cmp.visible)
                            (cmp.select_next_item)
                            ; elseif
                            (luasnip.expand_or_jumpable)
                            (vim.fn.feedkeys
                              (vim.api.nvim_replace_termcodes
                                "<Plug>luasnip-expand-or-jump"
                                true true true) "")
                            ; else
                            (fallback)))
               :<S-Tab> (fn [fallback]
                          (if (cmp.visible)
                              (cmp.select_prev_item)
                              ; elseif
                              (luasnip.jumpable -1)
                              (vim.fn.feedkeys 
                                (vim.api.nvim_replace_termcodes 
                                  "<Plug>luasnip-jump-prev"
                                  true true true) "")
                              ; else
                              (fallback)))}
     :sources [{:name "nvim_lsp"}
               {:name "luasnip"}]}))
```

