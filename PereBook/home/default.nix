{ config, pkgs, lib, modules, dotfiles, assets, ... }: # TODO remove dotfiles
{
  imports = [
    /${modules}/home
    # Nvim
    # Sway
    ./packages.nix
  ];

  programs.neovim = let
    lsp_servers = with pkgs; {
      rust-tools = {
        package = rust-analyzer;
        config = { settings = { rust-analyzer =
          { checkOnSave = { command = "clippy"; }; }; }; };
      };
      texlab = texlab;
      rnix = rnix-lsp;
      ccls = ccls;
      pyright = nodePackages.pyright;
      jdtls  = {
        package = jdt-language-server; # Java
        config.cmd = ["jdt-language-server" "-data" "${config.home.homeDirectory}/.jdt/workspace"];
      };
      yamlls = nodePackages.yaml-language-server;
      html = rec {
        package = nodePackages.vscode-langservers-extracted;
        config.cmd = ["${package}/bin/vscode-html-language-server" "--stdio"];

      };
      cssls = rec {
        package = nodePackages.vscode-langservers-extracted;
        config.cmd = ["${package}/bin/vscode-css-language-server" "--stdio"];
      };
      jsonls = rec {
        package = nodePackages.vscode-langservers-extracted;
        config.cmd = ["${package}/bin/vscode-json-language-server" "--stdio"];
      };
      eslint = rec { # JS (EcmaScript) and TS
        package = nodePackages.vscode-langservers-extracted;
        config = {
          cmd = ["${package}/bin/vscode-eslint-language-server" "--stdio"];
          settings = { packageManager = "pnpm"; };
        };
      };
      efm = let
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
      in {
        package = efm-langserver;
        config = {
          settings = {
            inherit languages;
          };
          filetypes = builtins.attrNames languages;
        };
      };
    };
    lsp_servers_config = let
      value_to_lua = value:
        if builtins.isAttrs value then
          set_to_lua value
        else if builtins.isList value then
          list_to_lua value
        else if builtins.isBool value then
          if value then "true" else "false"
        else if builtins.isString value then
          ''"${value}"''
        else
          ''${value}'';
      list_to_lua = list: "{" + builtins.toString
        (builtins.map (e: value_to_lua e + ", ") list) + "}";
      set_to_lua = set: "{" +
        builtins.toString (builtins.attrValues (builtins.mapAttrs
          (name: value: ''["${name}"] = ${value_to_lua value},'') set
        )) + "}";
    in set_to_lua (builtins.mapAttrs
      (_: x: x.config or {}) lsp_servers);
  in {
    enable = true;
    extraConfig = ''
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
      set completeopt=menuone,noselect
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
    '';
    extraPackages = builtins.map (x: x.package or x)
      (builtins.attrValues lsp_servers);
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
      rust-tools-nvim
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
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
                 f = map ("<cmd>lua vim.lsp.buf.format{async=true}<CR>", "Format buffer")
               },
               e = map ("<cmd>lua vim.diagnostic.open_float()<CR>", "Show line diagnostics"),
               q = map ("<cmd>lua vim.diagnostic.set_loclist()<CR>", "Set loclist")
             },
             ["[d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to previous"),
             ["]d"] = map ("<cmd>lua vim.diagnostic.goto_prev()<CR>", "Go to next"),
            }
          end
          local servers = ${lsp_servers_config}

          for lsp,cfg in pairs(servers) do
            cfg.on_attach = on_attach
            cfg.capabilities = capabilities
            if lsp == "rust-tools" then
              require"rust-tools".setup { server = cfg }
            else
              nvim_lsp[lsp].setup(cfg)
            end
          end
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
    ];
  };

  appDefaultForMimes."nvim.desktop" = "text/plain";
  programs.waybar = {
    enable = true;
    settings = [
      {
        modules = null;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "custom/media"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          # "mpd"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          # "backlight"
          # "keyboard-state"
          # "sway/language"
          "battery"
          "battery#bat2"
          "clock"
          "tray"
        ];
        clock = {
          tooltip-format = "{: %H:%M:%S\n %Y-%m-%d\n<big>%Y %B</big>}\n<tt><small>{calendar}</small></tt>";
          format = "{:%H:%M}";
          format-alt = "{:%H:%M:%S}";
          interval = 1;
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon} ";
          format-bluetooth-muted = "  ";
          # format-bluetooth-muted = " {icon}";
          format-muted = "";
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
          format-icons = {
            default = ["" "" ""];
            headphones = "";
            # handsfree = "";
            # headset = "";
            phone = "";
            portable = "";
            car = "";
          };
        };
        cpu = {
          format = "{usage}% ";
        };
        memory = {
          format = "{}% ";
        };
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        network = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ﯱ";
          format-linked = "{ifname} (No IP) ﯳ";
          format-disconnected = "";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 20;
          };
          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
          on-scroll-up = "light -A 1";
          on-scroll-down = "light -U 1";
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            deactivated = "鈴";
            activated = "零";
          };
        };
        height = 20;
        spacing = 0;
      }
    ];
    style = ''
        * {
          border: none;
          border-radius: 10px;
          font-family: "JetbrainsMono Nerd Font" ;
          font-size: 12px;
          color: #161320;
          min-height: 10px;
        }

        window#waybar {
          background: transparent;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        tooltip label {
          color: white;
        }

        #window {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 10px;
          padding-right: 10px;
          margin-bottom: 0px;
          transition: none;
          background: rgba(249, 249, 249, 0.65);
        }
        #waybar.empty #window {
          background: transparent;
        }

        #workspaces {
          margin-top: 3px;
          margin-left: 4px;
          margin-bottom: 0px;
          background: rgba(249, 249, 249, 0.65);
          transition: none;
        }

        #workspaces button {
          transition: none;
          background: transparent;
          min-width: 16px;
          padding: 4px;
        }

        #workspaces button.focused {
          background: rgba(249, 249, 249, 0.4);
        }

        #workspaces button:hover {
          background: rgba(193, 193, 193, 0.65);
        }

        #network {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 12px;
          margin-bottom: 0px;
          transition: none;
          background: #bd93f9;
        }

        #pulseaudio {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 12px;
          margin-bottom: 0px;
          transition: none;
          color: #1A1826;
          background: #FAE3B0;
        }

        #battery {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 12px;
          margin-bottom: 0px;
          transition: none;
          background: #B5E8E0;
        }

        #battery.charging, #battery.plugged {
          background-color: #B5E8E0;
        }

        #battery.critical:not(.charging) {
          background-color: #B5E8E0;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        @keyframes blink {
          to {
            background-color: #BF616A;
            color: #B5E8E0;
          }
        }

        #temperature {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 10px;
          margin-bottom: 0px;
          transition: none;
          background: #F8BD96;
        }
        #clock {
          margin-top: 3px;
          margin-left: 4px;
          margin-right: 4px;
          padding-left: 10px;
          padding-right: 10px;
          margin-bottom: 0px;
          transition: none;
          background: #ABE9B3;
          /*background: #1A1826;*/
        }

        #memory {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 12px;
          margin-bottom: 0px;
          transition: none;
          background: #DDB6F2;
        }
        #cpu {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 12px;
          margin-bottom: 0px;
          transition: none;
          background: #96CDFB;
        }

        #tray {
          margin-top: 3px;
          margin-left: 0px;
          margin-right: 4px;
          padding-left: 10px;
          margin-bottom: 0px;
          padding-right: 10px;
          transition: none;
          color: #B5E8E0;
          background: #161320;
        }

        #custom-launcher {
          font-size: 24px;
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 10px;
          padding-right: 5px;
          transition: none;
          color: #89DCEB;
          background: #161320;
        }

        #custom-power {
          font-size: 20px;
          margin-top: 3px;
          margin-left: 4px;
          margin-right: 4px;
          padding-left: 10px;
          padding-right: 5px;
          margin-bottom: 0px;
          transition: none;
          background: #F28FAD;
        }

        #idle_inhibitor {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 8px;
          padding-right: 12px;
          margin-bottom: 0px;
          transition: none;
          background: #C9CBFF;
        }

        #mode {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 10px;
          padding-right: 10px;
          margin-bottom: 0px;
          transition: none;
          background: #E8A2AF;
        }

        #custom-media {
          margin-top: 3px;
          margin-left: 4px;
          padding-left: 10px;
          padding-right: 10px;
          margin-bottom: 0px;
          transition: none;
          background: #F2CDCD;
        }
    '';
  };
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
      modifier = "Mod4";
      input."*".xkb_layout = "eu";
      input."*".xkb_numlock = "enabled";
      terminal = "kitty";
      menu = ''wofi --show=drun -i --prompt=""'';
      floating.criteria = [
        { app_id = "firefox"; title = "^Developer Tools [-—]"; }
        { app_id = "file-roller"; title = "Extract"; }
        { app_id = "file-roller"; title = "Compress"; }
        { app_id = "nemo"; title = "Properties"; }
        { app_id = "pavucontrol"; }
        { app_id = "qalculate-gtk"; }
        { app_id = "copyq"; }
      ];
      window.commands = [
        { criteria = { app_id = "firefox"; title = ".*[Ss]haring (Indicator|your screen)"; }; command = "floating enable, move to scratchpad"; }
        { criteria = { app_id = "firefox"; title = "^Picture-in-Picture$"; }; command = "floating enable, sticky enable, border none, inhibit_idle open"; }
        { criteria = { shell = "xwayland"; }; command = ''title_format "%title [%shell]"''; } # TODO: does not work for waybar
      ];
      gaps.inner = 5;
      colors.unfocused = let transparent = "#00000000"; in {
        background = "#222222";
        border = transparent;
        childBorder = transparent;
        indicator = "#292d2e";
        text = "#888888";
      };
      gaps.smartBorders = "on";
      keybindings = lib.mkOptionDefault
        (with config.wayland.windowManager.sway.config; {
          "${modifier}+Shift+e" = ''
            exec sh -c ' \
              case $(echo -e "Shutdown\nSuspend\nReboot\nLogout" | wofi --dmenu -i --prompt="Logout menu") in \
                "Shutdown") systemctl poweroff;; \
                "Suspend") systemctl suspend;; \
                "Reboot") systemctl reboot;; \
                "Logout") swaymsg exit;; \
              esac \
            '
          '';
          "--locked XF86AudioRaiseVolume" = "exec pamixer -u -i 5";
          "--locked XF86AudioLowerVolume" = "exec pamixer -d 5";
          "--locked XF86AudioMute" = "exec pamixer -t";
          "--locked XF86MonBrightnessDown" = "exec light -U 2";
          "--locked XF86MonBrightnessUp" = "exec light -A 2";
          "${modifier}+Ctrl+Shift+${left}" = "move workspace to output left";
          "${modifier}+Ctrl+Shift+${down}" = "move workspace to output down";
          "${modifier}+Ctrl+Shift+${up}" = "move workspace to output up";
          "${modifier}+Ctrl+Shift+${right}" = "move workspace to output right";
          "${modifier}+Ctrl+Shift+Left" = "move workspace to output left";
          "${modifier}+Ctrl+Shift+Down" = "move workspace to output down";
          "${modifier}+Ctrl+Shift+Up" = "move workspace to output up";
          "${modifier}+Ctrl+Shift+Right" = "move workspace to output right";
          "Ctrl+Alt+l" = "exec swaylock --screenshots --clock --indicator --effect-blur 7x5 --fade-in 0.2";
          "${modifier}+p" = "exec grimshot save active";       # Active window
          "${modifier}+Shift+p" = "exec grimshot save area";   # Select area
          "${modifier}+Mod1+p" = "exec grimshot save output";  # Whole screen
          "${modifier}+Ctrl+p" = "exec grimshot save window";  # Choose window
          "${modifier}+y" = "exec grimshot copy active";       # Active window
          "${modifier}+Shift+y" = "exec grimshot copy area";   # Select area
          "${modifier}+Mod1+y" = "exec grimshot copy output";  # Whole screen
          "${modifier}+Ctrl+y" = "exec grimshot copy window";  # Choose window
          "${modifier}+z" = "exec firefox";
          "${modifier}+x" = "exec nemo";
          "${modifier}+v" = "exec kitty nvim";
          "${modifier}+q" = "exec copyq toggle";
        } // builtins.listToAttrs (builtins.concatMap
          ({ name, value }:
            let
              ws = builtins.toString value;
            in
            [
              { name = "${modifier}+${name}"; value = "workspace number ${ws}"; }
              { name = "${modifier}+Shift+${name}"; value = "move container to workspace number ${ws}"; }
              { name = "${modifier}+Ctrl+${name}"; value = "move container to workspace number ${ws}, workspace number ${ws}"; }
            ])
          ([
            { name = "grave"; value = 0; }
            { name = "Escape"; value = 10; }
          ] ++ (map
            (n: { name = builtins.toString n; value = n; })
            [ 1 2 3 4 5 6 7 8 9 ])
          ++ map
            (n: { name = "F${builtins.toString n}"; value = 10 + n; })
            [ 1 2 3 4 5 6 7 8 9 10 11 12 ]
          )
        ));
    };
    extraConfig = ''
      exec ${pkgs.copyq}/bin/copyq
      exec ${pkgs.wpaperd}/bin/wpaperd
    '';
  };
  programs.fish.loginShellInit = lib.mkBefore ''
    if test (tty) = /dev/tty1
      exec sway &> /dev/null
    end
  '';
  xdg.configFile."wofi/config".text = ''
    allow_images=true # Enable icons
    insensitive=true  # Case insensitive search
  '';
  programs.mako = {
    enable = true;
  };
  services.wlsunset = {
    enable = true;
    latitude = "46"; # North
    longitude = "13"; # East
  };
  services.kanshi = {
    enable = true;
  };
  services.swayidle = {
    enable = true;
    timeouts = [{
      timeout = 300;
      command = ''${pkgs.sway}/bin/swaymsg "output * dpms off"'';
      resumeCommand = ''${pkgs.sway}/bin/swaymsg "output * dpms on"'';
    }];
  };
  xdg.configFile."wpaperd/output.conf".text = ''
    [default]
    path = "${dotfiles}/flake/wallpapers"
    duration = "1m"
  '';
  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita";
      package = pkgs.adwaita-qt;
    };
  };
  gtk.enable = true;
  gtk.iconTheme = {
    name = "Tela";
    package = pkgs.tela-icon-theme;
  };
  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = config.gtk.iconTheme.name;
  };
  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
  };
  appDefaultForMimes."telegramdesktop.desktop" = "x-scheme-handler/tg";
  home.sessionVariables = {
    PNPM_HOME = "${config.home.homeDirectory}/.pnpm-global";
  };
  home.sessionPath = [
    config.home.sessionVariables.PNPM_HOME
  ];
  systemd.user.services.polkit-agent = {
    Unit = {
      Description = "Runs polkit authentication agent";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      RestartSec = 5;
      Restart = "always";
    };
  };
  # TODO remove previous in favour of
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "batt" ''
      ${bluetooth_battery}/bin/bluetooth_battery AC:12:2F:50:BB:3A
    '')
  ];
  xdg.configFile."OpenTabletDriver/settings.json".source = /${assets}/tablet.json;
}

