{ config, pkgs, lib, inputs, ... }:
with inputs.nix2lua.lib;
{
  options = {
    nvimLSP = with lib; with types; let
      packagesType = coercedTo package toList (listOf package);
      configType = nullOr (coercedTo (attrsOf anything) toLua lines);
      packageWithConfigType = coercedTo packagesType (p: { packages = p; }) (submodule ({ config, options, ... }: {
        options = {
          packages = mkOption {
            type = packagesType;
            default = [ ];
          };
          package = mkOption {
            type = nullOr package;
            default = null;
            description = "Alias of `pakcages' for single package";
          };
          config = mkOption {
            type = configType;
            default = null;
            apply = x: if x == null || x == "" then "{}" else x;
          };
        };
        config.packages = mkIf (config.package != null) (mkAliasDefinitions options.package);
      }));
    in
    mkOption {
      type = attrsOf packageWithConfigType;
      default = { };
    };
  };

  config = {
    programs.neovim = with lib; {
      extraPackages = concatMap (getAttr "packages") (attrValues config.nvimLSP);
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = let
            lspConfig = toLua (mapAttrs (name: value: raw
              value.config) config.nvimLSP);
          in
          ''
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
            end
            local servers = ${lspConfig}

            for lsp,cfg in pairs(servers) do
              cfg.on_attach = on_attach
              cfg.capabilities = capabilities
              if lsp == "rust-tools" then
                require"rust-tools".setup { server = cfg }
              else
                nvim_lsp[lsp].setup(cfg)
              end
            end
          '';
        }
      ];
    };
  };
}
