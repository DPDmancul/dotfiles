# Haskell

```nix modules/home/packages/developing/haskell.nix
{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    (haskellPackages.ghcWithPackages (pkgs: [ cabal-install ]))
    haskell-language-server
  ];
  <<<modules/home/packages/developing/haskell>>>
}
```

### Neovim support

```nix "modules/home/packages/developing/haskell" +=
programs.neovim.plugins = with pkgs.vimPlugins; [
  {
    plugin = haskell-tools-nvim;
    type = "lua";
    config = ''
      <<<modules/home/packages/developing/haskell-tools-config>>>
    '';
  }
];
```

```lua "modules/home/packages/developing/haskell-tools-config" +=
vim.g.haskell_tools = {
  hls = {
    on_attach = function(client, bufnr, ht)
      local wk = require "which-key"
      local map = function (from, to, ...)
        return {
          from, to, ...,
          buffer = bufnr,
          noremap = true,
          silent = true
        }
      end
      wk.add {
        <<<modules/home/nvim/keymap-lsp-keybind>>>
      }
      wk.add {
        { "<leader>be", ht.lsp.buf_eval_all, desc = "Eval buffer" },
        { "<leader>br", function() ht.repl.toggle(vim.api.nvim_buf_get_name(0)) end, desc = "Buffer repl" },
        { "<leader>hs", ht.hoogle.hoogle_signature, desc = "Hoogle signature" },
        { "<leader>hr", ht.repl.toggle, desc = "Repl" },
      }
    end,
  },
}
```
