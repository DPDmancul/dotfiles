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
              wk.add {
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
      '';
    }
  ];
}
