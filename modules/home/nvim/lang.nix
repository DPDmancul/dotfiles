{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraConfig = ''
      set completeopt=menuone,noselect
    '';
    plugins = with pkgs; with vimPlugins; [
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
      nvim-cmp
      cmp-nvim-lsp
      cmp_luasnip
      luasnip
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
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
        '';
      }
    ];
  };

}
