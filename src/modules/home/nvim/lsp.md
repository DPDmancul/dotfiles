# Language Server Protocol

Options for easily setup LSP servers for neovim.

```nix modules/home/nvim/lsp.nix
{ config, pkgs, lib, ... }:
with lib.generators;
{
  options = {
    nvimLSP = with lib; with types; let
      packagesType = coercedTo package toList (listOf package);
      configType = nullOr (coercedTo (attrsOf anything) (toLua {}) lines);
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
        {
          plugin = nvim-lspconfig;
          type = "lua";
          config = let
            lspConfig = toLua {} (mapAttrs (name: value: mkLuaInline
              value.config) config.nvimLSP);
          in
          ''
            <<<modules/home/nvim/lsp-config>>>
          '';
        }
      ];
    };
  };
}
```

Enable some language servers with the additional completion capabilities
offered by blink.cmp

```lua "modules/home/nvim/lsp-config" +=
vim.lsp.config(
  "*",
  {
    capabilities = require"blink.cmp".get_lsp_capabilities(),
  }
)

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    local wk = require("which-key")

    local map = function(from, to, ...)
      return {
        from, to, ...,
        buffer = bufnr,
        noremap = true,
        silent = true,
      }
    end

    wk.add {
      <<<modules/home/nvim/keymap-lsp-keybind>>>
    }
  end,
})

local servers = ${lspConfig}

for lsp,cfg in pairs(servers) do
  vim.lsp.enable(lsp)
  vim.lsp.config(lsp, cfg)
end
```

