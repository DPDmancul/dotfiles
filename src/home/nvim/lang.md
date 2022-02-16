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

Declare LSP servers

```nix "lsp-servers" +=
rust-tools = {
  package = rust-analyzer;
  config = { settings = { rust-analyzer =
    { checkOnSave = { command = "clippy"; }; }; }; };
};
texlab = texlab;
bashls = nodePackages.bash-language-server;
ccls = ccls;
pyright = nodePackages.pyright;
denols = deno; # JS and TS
yamlls = nodePackages.yaml-language-server;
html = {
  package = nodePackages.vscode-html-languageserver-bin;
  config = { cmd = ["html-languageserver" "--stdio"]; };
};
cssls = {
  package = nodePackages.vscode-css-languageserver-bin;
  config = { cmd = ["css-languageserver" "--stdio"]; };
};
jsonls = {
  package = nodePackages.vscode-json-languageserver;
  config = { cmd = ["vscode-json-languageserver" "--stdio"]; };
};
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
      servers ${lsp_servers_config}]
  (each [lsp cfg (pairs servers)]
    (tset cfg :on_attach on_attach)
    (tset cfg :capabilities capabilities)
    ((. nvim_lsp lsp :setup) cfg))
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

