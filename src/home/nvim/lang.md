# Neovim language support

Add support for some languages

## Quarto Pandoc

```nix "nvim-plugins" +=
vim-pandoc-syntax
{
  plugin = (vimUtils.buildVimPlugin rec {
    name = "quarto-vim";
    src = fetchFromGitHub {
      owner = "quarto-dev";
      repo = name;
      rev = "216247339470794e74a5fda5e5515008d6dc1057";
      sha256 = "HTqvZQY6TmVOWzI5N4LEaYfLg1AxWJZ6IjHhwuYQwI8=";
    };
  });
}
```

## LSP

Use the power of Language Server Protocol for a better developing experience

### LSP utils

Better UI for LSP

```nix "nvim-plugins" +=
# popfix
# {
#   plugin = nvim-lsputils;
#   type = "lua";
#   config = ''
#     vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
#     vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
#     vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
#     vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
#     vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
#     vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
#     vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
#     vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
#   '';
# }
```

### LSP hints

```nix "nvim-plugins" +=
{
  plugin = lsp_signature-nvim;
  type = "lua";
  config = ''require"lsp_signature".setup{}'';
}
# {
#   plugin = virtual-types-nvim;
#   type = "lua";
#   config = '''';
# }
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
rnix = rnix-lsp;
ccls = ccls;
pyright = nodePackages.pyright;
jdtls  = {
  package = jdt-language-server; # Java
  config.cmd = ["jdt-language-server" "-data" "${config.home.homeDirectory}/.jdt/workspace"];
};
yamlls = nodePackages.yaml-language-server;
html = rec {
  package = nodePackages.vscode-langservers-extracted;
  config.cmd = ["${package}/bin/vscode-html-language-server" "--stdio"];

};
cssls = rec {
  package = nodePackages.vscode-langservers-extracted;
  config.cmd = ["${package}/bin/vscode-css-language-server" "--stdio"];
};
jsonls = rec {
  package = nodePackages.vscode-langservers-extracted;
  config.cmd = ["${package}/bin/vscode-json-language-server" "--stdio"];
};
eslint = rec { # JS (EcmaScript) and TS
  package = nodePackages.vscode-langservers-extracted;
  config = {
    cmd = ["${package}/bin/vscode-eslint-language-server" "--stdio"];
    settings = { packageManager = "pnpm"; };
  };
};
efm = let
  languages = {
    sh = [
      {
        lintCommand = "${shellcheck}/bin/shellcheck -f gcc -x";
        lintSource = "shellcheck";
        lintFormats = [
          "%f:%l:%c: %trror: %m"
          "%f:%l:%c: %tarning: %m"
          "%f:%l:%c: %tote: %m"
        ];
      }
      {
        formatCommand = "${shfmt}/bin/shfmt -ci -s -bn";
        formatStdin = true;
      }
    ];
    make = [
      {
        lintCommand = "${checkmake}/bin/checkmake";
        lintStdin = true;
      }
    ];
  };
in {
  package = efm-langserver;
  config = {
    settings = {
      inherit languages;
    };
    filetypes = builtins.attrNames languages;
  };
};
```

vscode-eslint requires some addendum:

```nix "home-packages" +=
nodePackages.pnpm
# You must manually install `pnpm i -g eslint`
# and run `pnpx eslint --init` in all projects
```

```nix "home-env" +=
PNPM_HOME = "${config.home.homeDirectory}/.pnpm-global";
```

```nix "home-path" +=
config.home.sessionVariables.PNPM_HOME
```


Enable some language servers with the additional completion capabilities
offered by nvim-cmp

```lua "lsp-config" +=
local nvim_lsp = require "lspconfig"
local capabilities = require"cmp_nvim_lsp".default_capabilities(vim.lsp.protocol.make_client_capabilities())
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
      luasnip.lsp_expand(args.body)
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

