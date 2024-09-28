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
      wk.register {
        <<<modules/home/nvim/keymap-lsp-keybind>>>
      }
      wk.register {
        ["<leader>"] = {
          b = {
            e = map (ht.lsp.buf_eval_all, "Eval buffer");
            r = map (function() ht.repl.toggle(vim.api.nvim_buf_get_name(0)) end, "Buffer repl")
          };
          h = {
            s = map (ht.hoogle.hoogle_signature, "Hoogle signature");
            r = map (ht.repl.toggle, "Repl")
          };
        }
      }
    end,
  },
}
```
