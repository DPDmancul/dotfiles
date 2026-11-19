{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraConfig = ''
      augroup filetypedetect
        autocmd BufNew,BufNewFile,BufRead *.env :setfiletype dotenv
      augroup END
      set completeopt=menuone,noselect
    '';
    plugins = with pkgs; with vimPlugins; [
      vim-pandoc-syntax
      # {
      #   plugin = (vimUtils.buildVimPlugin rec {
      #     name = "quarto-vim";
      #     src = fetchFromGitHub {
      #       owner = "quarto-dev";
      #       repo = name;
      #       rev = "216247339470794e74a5fda5e5515008d6dc1057";
      #       sha256 = "HTqvZQY6TmVOWzI5N4LEaYfLg1AxWJZ6IjHhwuYQwI8=";
      #     };
      #   });
      # }
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
      {
        plugin = blink-cmp;
        type = "lua";
        config = ''
          require"blink.cmp".setup {
            cmdline = {
              completion = { menu = { auto_show = true } },
            },
          }
        '';
      }
    ];
  };

  nvimLSP = with pkgs; {
    yamlls = yaml-language-server;
    jsonls = rec {
      package = vscode-langservers-extracted;
      config.cmd = ["${package}/bin/vscode-json-language-server" "--stdio"];
    };
    lemminx = lemminx; # xml
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
}
