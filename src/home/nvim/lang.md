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
  config = ''
    let g:vimtex_view_general_viewer =  'okular'
  '';
}
```

## Agda

```nix "nvim-plugins" +=
{
  plugin = (buildVimPlugin {
    name = "agda-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "Isti115";
      repo = "agda.nvim";
      rev = "c7da627547e978b4ac3780af1b8f418c8b12ff98";
      sha256 = "sha256-c7UjrVbfaagIJS7iGdjWiFlpLUDHGc0I3ZGoUPECL00=";
    };
  });
  config = ''
    let g:agda_theme = "light"
    function! AgdaMapping()
      noremap <silent> <buffer> <LocalLeader>L :lua require('agda').load()<cr> " To not clash with VimTeX
    endfunction
    autocmd BufWinEnter *.agda call AgdaMapping()
    autocmd BufWinEnter *.lagda* call AgdaMapping()
    digr ZZ 8484
    digr NN 8469
    digr RR 8477
    digr FF 120125
  '';
}
{
  plugin = (buildVimPlugin {
    name = "vim-agda";
    src = pkgs.fetchFromGitHub {
      owner = "msuperdock";
      repo = "vim-agda";
      rev = "1695060850b5991e8aded0861fae0c31877950a7";
      sha256 = "sha256-xp/aeki1f0DqyOjv8Yw+KUfPOeRRJDW86vgw0YcOIlc=";
    };
  });
}
```


## LSP

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
  type = "lua";
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
jdtls  = {
  package = jdt-language-server; # Java
  config = { cmd = ["jdt-language-server" "-data" "${config.home.homeDirectory}/.jdt/workspace"]; };
};
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

```lua "lsp-config" +=
local nvim_lsp = require "lspconfig"
local capabilities = require"cmp_nvim_lsp".update_capabilities(vim.lsp.protocol.make_client_capabilities())
local on_attach = function (client, bufnr)
  local wk = require "which-key"
  local map = function (from, to, ...)
    return {
      from, to, ...,
      buffer = bufnr,
      noremap = true,
      silent = true
    }
  end
  wk.register {
   <<<nvim-lsp-keybind>>>
  }
end
local servers = ${lsp_servers_config}

for lsp,cfg in pairs(servers) do
  cfg.on_attach = on_attach
  cfg.capabilities = capabilities
  if lsp == "rust-tools" then
    require"rust-tools".setup { server = cfg }
  else
    nvim_lsp[lsp].setup(cfg)
  end
end
```

nvim-cmp setup

```lua "lsp-config" +=
local cmp = require "cmp"
local luasnip = require "luasnip"
cmp.setup {
  snippet = {
    expand = function (args)
      luasnip.lsp_expand(args.body())
    end
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    },
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end
  },  
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" }
  }
}
```

