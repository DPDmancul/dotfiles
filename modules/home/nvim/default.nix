{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
    ./lsp.nix
  ];

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set termguicolors     " Enable gui colors
      set cursorline        " Enable highlighting of the current line
      set signcolumn=yes    " Always show signcolumn or it would frequently shift
      set pumheight=10      " Make popup menu smaller
      set cmdheight=0       " Automatically hide command line
      set colorcolumn=+1    " Draw colored column one step to the right of desired maximum width
      set linebreak         " Wrap long lines at 'breakat' (if 'wrap' is set)
      set scrolloff=2       " Show more lines on top and bottom
      set title             " Enable window title
      set list              " Show tabs and trailing spaces
      set number          " Show line numbers
      set relativenumber  " Show relative line numbers
      set numberwidth=1   " Minimum number width
      set conceallevel=2
      set noshowmode
      set whichwrap=b,s,h,l,<,>,[,] " Allow moving along lines when the start/end is reached
      set clipboard=unnamedplus     " Sync yank register with system clipboard
      set expandtab     " Convert tabs to spaces
      set tabstop=2     " Display 2 spaces for a tab
      set shiftwidth=2  " Use this number of spaces for indentation
      set smartindent   " Make indenting smart
      set autoindent    " Use auto indent
      set breakindent   " Indent wrapped lines to match line start
      set virtualedit=block
      set formatlistpat=^\\s*\\w\\+[.\)]\\s\\+\\\\|^\\s*[\\-\\+\\*]\\+\\s\\+
      set foldmethod=indent  " Set 'indent' folding method
      set nofoldenable       " Start with folds opened
      let g:mapleader = ' '
      nnoremap <cr> :
      vnoremap <cr> :
      set mouse=a     " Enable mouse
      set lazyredraw  " Use lazy redraw
      set undofile    " Enable persistent undo
      set hidden      " Allow buffers in background
      set ignorecase " Enable case insensitive search
      set smartcase  " when using uppercase make case sensitive
      set incsearch  " Show search results while typing
      let $GIT_EDITOR = 'nvr -cc split --remote-wait'
      autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
      set spell
      set spelllang=en,it     " Define spelling dictionaries
      set complete+=kspell    " Add spellcheck options for autocomplete
      set spelloptions=camel  " Treat parts of camelCase words as separate words
      set completeopt=menuone,noselect
    '';
    plugins = with pkgs; with vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          local wk = require "which-key"
          wk.setup {
            spelling = {
              enabled = true,
              suggestions = 10
            },
            window = {
              margin = {0, 0, 0, 0},
              padding = {1, 0, 1, 0,}
            }
          }
          local map = function (from, to, ...)
            return {
              from, to, ...,
              noremap = true,
              silent = true
            }
          end
          wk.register ( 
            {
              f = {
                name = "Find",
                r = map ("<cmd>Telescope resume<cr>", "Resume saerch"),
                f = map ("<cmd>Telescope find_files<cr>", "Files"),
                g = map ("<cmd>Telescope live_grep<cr>", "Grep"),
                b = map ("<cmd>Telescope buffers<cr>", "Buffers"),
                h = map ("<cmd>Telescope help_tags<cr>", "Help"),
                p = map ("<cmd>Telescope projects<cr>", "Projects"),
                e = map ("<cmd>Telescope file_browser<cr>", "Explore"),
                t = map ("<cmd>NvimTreeToggle<cr>", "File tree"),
                -- ["\\"] = map ("<cmd>Telescope termfinder find<cr>", "Terminals"),
                [":"] = map ("<cmd>Telescope commands<cr>", "Commands"),
                a = map ("<cmd>Telescope<cr>", "All telescopes"),
              },
              c = {
                name = "Code",
                e = map ("<cmd>FeMaco<cr>", "Edit fenced block"),
              },
              g = {
                name = "Git",
                g = map ("<cmd>Lazygit<cr>", "Lazygit"),
              },
              r = {
                name = "Reload",
                r = map ("<cmd>e<cr>", "File"),
                c = map ("<cmd>source ~/.config/nvim/init.vim<cr>", "Config"),
              },
              t = {
                name = "Table",
                m = "Toggle table mode",
                t = "To table"
              },
              u = map ("<cmd>UndotreeToggle<cr>", "Undo tree"),
            },
            { prefix = "<leader>" }
          )
          wk.register {
            ["]b"] = map ("<cmd>BufferLineCycleNext<cr>", "Next buffer"),
            ["]B"] = map ("<cmd>BufferLineMoveNext<cr>", "Move buffer right"),
            ["[b"] = map ("<cmd>BufferLineCyclePrev<cr>", "Previous buffer"),
            ["[B"] = map ("<cmd>BufferLineMovePrev<cr>", "Move buffer left"),
            gb = map ("<cmd>BufferLinePick<cr>", "Go to buffer"),
            gB = map ("<cmd>BufferLinePickClose<cr>", "Close picked buffer"),
          }
        '';
      }
      vim-numbertoggle
      lush-nvim
      {
        plugin = gruvbox-nvim;
        config = ''
          set background=light
          colorscheme gruvbox
        '';
      }
      lualine-lsp-progress
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require"lualine".setup {
            options = {
              section_separators = {
                left = "",
                right = ""
              },
              component_separators = {
                 left = "|",
                 right = "|"
              },
            },
            sections = {
              lualine_c = {
                "filename",
                "lsp_progress"
              },
              lualine_x = {
                "encoding",
                "fileformat",
                function ()
                  if vim.o.expandtab then
                    return vim.o.shiftwidth .. " ␣"
                  else
                    return vim.o.tabstop .. " ↹"
                  end
                end,
                "filetype"
              }
            }
          }
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require"bufferline".setup {
            options = {
              right_mouse_command = "vertical sbuffer %d",
              middle_mouse_command = "Bdelete! %d",
              close_command = "Bdelete! %d",
              show_close_icon = false,
              custom_filter = function(buf, buf_nums)
                -- Hide quickfix lists from bufferline
                return vim.bo[buf].buftype ~= "quickfix"
              end,
              offsets = {
                {
                  filetype = "NvimTree",
                  text = vim.fn.getcwd
                }
              }
            }
          }
        '';
      }
      {
        plugin = wilder-nvim;
        config = "call wilder#setup({'modes': [':', '/', '?']})";
      }
      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = ''
          require"toggleterm".setup {
            open_mapping = [[<c-\>]],
            shade_terminals = false
          }

          function _G.set_terminal_keymaps ()
            for from,to in pairs {
              ["<esc>"] = [[<C-\><C-n>]],
              ["<C-w><C-w>"] = [[<cmd>wincmd w<cr>]],
              ["<C-w>w"] = [[<cmd>wincmd w<cr>]],
              ["<C-w>h"] = [[<cmd>wincmd h<cr>]],
              ["<C-w>j"] = [[<cmd>wincmd j<cr>]],
              ["<C-w>k"] = [[<cmd>wincmd k<cr>]],
              ["<C-w>l"] = [[<cmd>wincmd l<cr>]],
            } do
              vim.api.nvim_buf_set_keymap(0, "t", from, to, {
                noremap = true,
                silent = true
              })
            end
          end

          vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"
          local lazygit = require"toggleterm.terminal".Terminal:new {
            cmd = "lazygit",
            hidden = true,
            count = 0,
            direction = "tab",
            on_open = function(term)
              term.old_laststatus = vim.opt_local.laststatus
              vim.opt_local.laststatus = 0
              vim.opt_local.signcolumn = "no"
              pcall(vim.api.nvim_buf_del_keymap, term.bufnr, "t", "<esc>")
            end,
            on_close = function(term)
              vim.opt_local.laststatus = term.old_laststatus
            end
          }
          function lazygit_toggle()
            lazygit:toggle()
          end
          vim.api.nvim_create_user_command("Lazygit", lazygit_toggle, {})
        '';
      }
      {
        plugin = (vimUtils.buildVimPlugin {
          name = "stickybuf-nvim";
          src = fetchFromGitHub {
            owner = "stevearc";
            repo = "stickybuf.nvim";
            rev = "db2965ccd97b3f1012b19a76d8541f9843b12960";
            sha256 = "J/j7pyvqdSfQUkcXw0krvw303N+FlgDN+wH0bAefOYw=";
          };
        });
        type = "lua";
        config = ''
          require("stickybuf").setup({
            buftype = {
              quickfix = "buftype", -- VimTeX
            },
            filetype = {
              toggleterm = "filetype",
            }
          })
        '';
      }
      {
        plugin = neoscroll-nvim;
        type = "lua";
        config = ''require"neoscroll".setup{}'';
      }
      editorconfig-nvim
      vim-sleuth
      {
        plugin = camelcasemotion;
        config = "let g:camelcasemotion_key = '\\'";
      }
      (vimUtils.buildVimPlugin {
        name = "vim-fanfingtastic";
        src = fetchFromGitHub {
          owner = "dahu";
          repo = "vim-fanfingtastic";
          rev = "6d0fea6dafbf3383dbab1463dbfb3b3d1b94b209";
          sha256 = "wmiKxuNjazkOWFcuMvDJzdPp2HhDu8CNL0rxu+8hrKs=";
        };
      })
      {
        plugin = suda-vim;
        config = "let g:suda_smart_edit = 1";
      }
      vim-table-mode
      nvim-ts-rainbow
      {
        plugin = nvim-treesitter.withPlugins (p: pkgs.tree-sitter.allGrammars);
        type = "lua";
        config = ''
          require"nvim-treesitter.configs".setup {
            highlight = {
              enable = true,
              disable = { "latex" },
            },
            incremental_selection = { enable = true },
            indentation = { enable = true },
            folding = { enable = true },
            -- rainbow parenthesis match
            rainbow = {
              enable = true,
              extended_mode = true, -- Also highlight non-bracket delimiters
              max_file_lines = nil
            }
          }
        '';
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''require"colorizer".setup{}'';
      }
      {
        plugin = nur.repos.m15a.vimExtraPlugins.nvim-FeMaco-lua;
        type = "lua";
        config = ''require"femaco".setup()'';
      }
      undotree
      (vimUtils.buildVimPlugin rec {
        name = "vim-xsampa";
        src = fetchFromGitHub {
          owner = "DPDmancul";
          repo = name;
          rev = "2a7ccb69c508e49126b541625e990b03a90e262f";
          sha256 = "te8pq/TxDepG/Lz4+rxfDa32K0sSWCFLcxlR3H79Wdg=";
        };
      })
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      # telescope-termfinder
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require "telescope"
          telescope.load_extension("file_browser")
          telescope.load_extension("projects")
          telescope.load_extension("fzf")
          -- telescope.load_extension("termfinder")
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require"gitsigns".setup()'';
      }
      {
        plugin = project-nvim;
        type = "lua";
        config = ''require"project_nvim".setup()'';
      }
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require"mini.indentscope".setup()
          require"mini.bufremove".setup()
          vim.api.nvim_create_user_command('Bdelete', function(args)
            MiniBufremove.delete(tonumber(args.args), args.bang)
          end, { bang = true, addr = 'buffers', nargs = '?' })
          vim.api.nvim_set_keymap('c', 'bd', 'Bdelete', {noremap = true})
          require"mini.ai".setup()
          require"mini.comment".setup()
          require"mini.pairs".setup()
          require"mini.surround".setup()
        '';
      }
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

  appDefaultForMimes."nvim.desktop" = "text/plain";

  # TODO remove
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
}
