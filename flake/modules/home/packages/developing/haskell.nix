{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    (haskellPackages.ghcWithPackages (pkgs: [ cabal-install ]))
    haskell-language-server
  ];
  programs.neovim.plugins = with pkgs.vimPlugins; [
    {
      plugin = haskell-tools-nvim;
      type = "lua";
      config = ''
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
                g = {
                  D = map ("<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration"),
                  d = map ("<cmd>lua vim.lsp.buf.definition()<CR>", "Go to defintion"),
                  I = map ("<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation"),
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
                    a = map ("<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action"),
                    f = map ("<cmd>lua vim.lsp.buf.format{async=true}<CR>", "Format buffer"),
                    l = map ("<cmd>lua vim.lsp.codelens.run()<CR>", "Code lens")
                  },
                  e = map ("<cmd>lua vim.diagnostic.open_float()<CR>", "Show line diagnostics"),
                  q = map ("<cmd>lua vim.diagnostic.set_loclist()<CR>", "Set loclist")
                },
                ["[d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous"),
                ["]d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to next"),
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
      '';
    }
  ];
}
