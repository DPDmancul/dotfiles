# Language Server Protocol

Options for easily setup LSP servers for neovim.

```nix modules/home/nvim/lsp.nix
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
            lspConfig = toLua (mapAttrs (name: value: mkLuaRaw
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
offered by nvim-cmp

```lua "modules/home/nvim/lsp-config" +=
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
```

