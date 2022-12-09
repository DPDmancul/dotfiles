# Neovim language support

Add support for some languages

```nix modules/home/nvim/lang.nix
{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraConfig = ''
      <<<modules/home/nvim/lang-config>>>
    '';
    plugins = with pkgs; with vimPlugins; [
      <<<modules/home/nvim/lang-plugins>>>
    ];
  };

  <<<modules/home/nvim/lang>>>
}
```

## Quarto Pandoc

```nix "modules/home/nvim/lang-plugins" +=
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

```nix "modules/home/nvim/lang-plugins" +=
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

```nix "modules/home/nvim/lang-plugins" +=
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

```nix "modules/home/nvim/lang-plugins" +=
nvim-cmp
cmp-nvim-lsp
cmp_luasnip
luasnip
{
  plugin = nvim-lspconfig;
  type = "lua";
  config = ''
    <<<modules/home/nvim/lang-lsp>>>
  '';
}
```

Declare common LSP servers

```nix "modules/home/nvim/lang" +=
nvimLSP = with pkgs; {
  rnix = rnix-lsp;
  yamlls = nodePackages.yaml-language-server;
  jsonls = rec {
    package = nodePackages.vscode-langservers-extracted;
    config.cmd = ["${package}/bin/vscode-json-language-server" "--stdio"];
  };
  efm = {
    package = efm-langserver;
    config =  let
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
    in
    {
      settings = {
        inherit languages;
      };
      filetypes = builtins.attrNames languages;
    };
  };
};
```

Set completeopt to have a better completion experience

```vim "modules/home/nvim/lang-config" +=
set completeopt=menuone,noselect
```

nvim-cmp setup

```lua "modules/home/nvim/lang-lsp" +=
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

