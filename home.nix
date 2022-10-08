{ config, pkgs, lib, dotfiles, ... }:
let
  wpaperd = with pkgs; rustPlatform.buildRustPackage rec {
    pname = "wpaperd";
    version = "0.1.0";

    src = fetchFromGitHub {
      owner = "danyspin97";
      repo = pname;
      rev = "89f32c907386af58587df46c10784ab4f17ed31e";
      sha256 = "n1zlC2afog0UazsJEBAzXpnhVDeP3xqpNGXlJ65umHQ=";
    };

    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      libxkbcommon
    ];

    cargoSha256 = "xIXmvMiOpgZgvA9C8tyzoW5ZA1rQ0e+/RuWdzJkoBsc=";
  };
in {
  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  programs.kitty = {
    enable = true;
    font = {
      name = "jetbrainsmono nerd font";
      size = 10;
    };
    settings = {
      url_style = "single";
      cursor                  = "#928374";
      background              = "#fbf1c7";
      foreground              = "#282828";
      selection_foreground    = "#665c54";
      selection_background    = "#d5c4a1";
      # white
      color0                  = "#fbf1c7";
      color8                  = "#9d8374";
      # red
      color1                  = "#cc241d";
      color9                  = "#9d0006";
      # green
      color2                  = "#98971a";
      color10                 = "#79740e";
      # yellow
      color3                  = "#d79921";
      color11                 = "#b57614";
      # blue
      color4                  = "#458588";
      color12                 = "#076678";
      # purple
      color5                  = "#b16286";
      color13                 = "#8f3f71";
      # aqua
      color6                  = "#689d6a";
      color14                 = "#427b58";
      # black
      color7                  = "#7c6f64";
      color15                 = "#3c3836";
      active_tab_background   = "#fbf1c7";
      inactive_tab_background = "#d5c4a1";
      tab_bar_background      = "none";

      wayland_titlebar_color = "background";
      tab_bar_edge        = "top";
      tab_bar_style       = "powerline";
      tab_powerline_style = "slanted";
      confirm_os_window_close = -2;
    };
  };
  programs.neovim = let
    lsp_servers = with pkgs; {
      rust-tools = {
        package = rust-analyzer;
        config = { settings = { rust-analyzer =
          { checkOnSave = { command = "clippy"; }; }; }; };
      };
      texlab = texlab;
      bashls = nodePackages.bash-language-server;
      ccls = ccls;
      pyright = nodePackages.pyright;
      denols = deno; # JS and TS
      jdtls  = {
        package = jdt-language-server; # Java
        config = { cmd = ["jdt-language-server" "-data" "${config.home.homeDirectory}/.jdt/workspace"]; };
      };
      yamlls = nodePackages.yaml-language-server;
      html = {
        package = nodePackages.vscode-html-languageserver-bin;
        config = { cmd = ["html-languageserver" "--stdio"]; };
      };
      cssls = {
        package = nodePackages.vscode-css-languageserver-bin;
        config = { cmd = ["css-languageserver" "--stdio"]; };
      };
      jsonls = {
        package = nodePackages.vscode-json-languageserver;
        config = { cmd = ["vscode-json-languageserver" "--stdio"]; };
      };
    };
    lsp_servers_config = let
      value_to_lua = value:
        if builtins.isAttrs value then
          set_to_lua value
        else if builtins.isList value then
          list_to_lua value
        else
          ''"${value}"'';
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
      set spell
      set spelllang=en,it     " Define spelling dictionaries
      set complete+=kspell    " Add spellcheck options for autocomplete
      set spelloptions=camel  " Treat parts of camelCase words as separate words
      set termguicolors     " Enable gui colors
      set cursorline        " Enable highlighting of the current line
      set signcolumn=yes  " Always show signcolumn or it would frequently shift
      set pumheight=10      " Make popup menu smaller
      set colorcolumn=+1  " Draw colored column one step to the right of desired maximum width
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
      let g:tex_flavor = 'latex'
      set completeopt=menuone,noselect
    '';
    extraPackages = builtins.map (x: x.package or x)
      (builtins.attrValues lsp_servers);
    plugins = with pkgs.vimPlugins; let
      inherit (pkgs.vimUtils) buildVimPlugin;
    in [
      plenary-nvim
      nvim-web-devicons
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
      diffview-nvim
      {
        plugin = neogit;
        type = "lua";
        config = ''
          require"neogit".setup{
            integrations = {
              diffview = true
            }
          }
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
                s = map (function () 
                    require"session-lens".search_session()
                  end, "Sessions"),
                e = map ("<cmd>Telescope file_browser<cr>", "Explore"),
                t = map ("<cmd>NvimTreeToggle<cr>", "File tree"),
                -- ["\\"] = map ("<cmd>Telescope termfinder find<cr>", "Terminals"),
                [":"] = map ("<cmd>Telescope commands<cr>", "Commands"),
                a = map ("<cmd>Telescope<cr>", "All telescopes"),
              },
              g = {
                name = "Git",
                g = map ("<cmd>Neogit<cr>", "Neo git"),
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
            ["<f3>"] = map ("<cmd>noh<cr>", "End search"),
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
          local close_cmd = "let s:close = %d | if bufnr('%%') == s:close | b# | endif | execute 'bd! '.s:close"
          require"bufferline".setup {
            options = {
              right_mouse_command = "vertical sbuffer %d",
              middle_mouse_command = close_cmd,
              close_command = close_cmd,
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
        '';
      }
      {
        plugin = (buildVimPlugin {
          name = "stickybuf-nvim";
          src = pkgs.fetchFromGitHub {
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
      (buildVimPlugin {
        name = "vim-fanfingtastic";
        src = pkgs.fetchFromGitHub {
          owner = "dahu";
          repo = "vim-fanfingtastic";
          rev = "6d0fea6dafbf3383dbab1463dbfb3b3d1b94b209";
          sha256 = "wmiKxuNjazkOWFcuMvDJzdPp2HhDu8CNL0rxu+8hrKs=";
        };
      })
      kommentary
      {
        plugin = suda-vim;
        config = "let g:suda_smart_edit = 1";
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''require"nvim-autopairs".setup{}'';
      }
      {
        plugin = surround-nvim;
        type = "lua";
        config = ''require"surround".setup{ mappings_style = "sandwich" }'';
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
              additional_vim_regex_highlighting = true
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
      vim-nix
      undotree
      (buildVimPlugin rec {
        name = "vim-xsampa";
        src = pkgs.fetchFromGitHub {
          owner = "DPDmancul";
          repo = name;
          rev = "2a7ccb69c508e49126b541625e990b03a90e262f";
          sha256 = "te8pq/TxDepG/Lz4+rxfDa32K0sSWCFLcxlR3H79Wdg=";
        };
      })
      {
        plugin = vimtex;
        config = ''
          let g:vimtex_view_general_viewer =  'okular'
        '';
      }
      nui-nvim
      {
        plugin = (buildVimPlugin rec {
          name = "nvim-lilypond-suite";
          src = pkgs.fetchFromGitHub {
            owner = "martineausimon";
            repo = name;
            rev = "803bf45a46c234bd18dbee6668460cea83a8172e";
            sha256 = "nbqywtDOLS6bco+tLqAmZYvG5Ol0qE4EcXVvWHwXK0s=";
          };
        });
      }
      vim-pandoc-syntax
      {
        plugin = (buildVimPlugin rec {
          name = "quarto-vim";
          src = pkgs.fetchFromGitHub {
            owner = "quarto-dev";
            repo = name;
            rev = "216247339470794e74a5fda5e5515008d6dc1057";
            sha256 = "HTqvZQY6TmVOWzI5N4LEaYfLg1AxWJZ6IjHhwuYQwI8=";
          };
        });
      }
      {
        plugin = (buildVimPlugin {
          name = "agda-nvim";
          src = pkgs.fetchFromGitHub {
            owner = "Isti115";
            repo = "agda.nvim";
            rev = "c7da627547e978b4ac3780af1b8f418c8b12ff98";
            sha256 = "c7UjrVbfaagIJS7iGdjWiFlpLUDHGc0I3ZGoUPECL00=";
          };
        });
        config = ''
          let g:agda_theme = "light"
          function! AgdaMapping()
            noremap <silent> <buffer> <LocalLeader>L :lua require('agda').load()<cr> " To not clash with VimTeX
          endfunction
          autocmd BufWinEnter *.agda call AgdaMapping()
          autocmd BufWinEnter *.lagda* call AgdaMapping()
          digr ZZ 8484
          digr NN 8469
          digr RR 8477
          digr FF 120125
        '';
      }
      {
        plugin = (buildVimPlugin rec {
          name = "vim-agda";
          src = pkgs.fetchFromGitHub {
            owner = "msuperdock";
            repo = name;
            rev = "1695060850b5991e8aded0861fae0c31877950a7";
            sha256 = "xp/aeki1f0DqyOjv8Yw+KUfPOeRRJDW86vgw0YcOIlc=";
          };
        });
      }
      symbols-outline-nvim
      {
        plugin = lspsaga-nvim;
        type = "lua";
        config = ''require"lspsaga".init_lsp_saga()'';
      }
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
          local capabilities = require"cmp_nvim_lsp".update_capabilities(vim.lsp.protocol.make_client_capabilities())
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
               i = map ("<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation"),
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
                 name = "Code",
                 a = map ("<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action"),
                 f = map ("<cmd>lua vim.lsp.buf.formatting()<CR>", "Format buffer")
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
                luasnip.lsp_expand(args.body())
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
          tooltip-format = "{: %H:%M:%S\n %Y/%m/%d\n<big>%Y %B</big>}\n<tt><small>{calendar}</small></tt>";
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
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      forceWayland = true;
      extraPolicies = {
        ExtensionSettings = let
          ext = name: {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
          };
        in {
          "*" = {
            installation_mode = "blocked";
            blocked_install_message = "Extensions managed by home-manager.";
          };
          "it-IT@dictionaries.addons.mozilla.org" = ext "dizionario-italiano";
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = ext "bitwarden-password-manager";
          # "vim-vixen@i-beam.org" = ext "vim-vixen";
          "{7be2ba16-0f1e-4d93-9ebc-5164397477a9}" = ext "videospeed";
          "proxydocile@unipd.it"= {
            installation_mode = "force_installed";
            install_url = "https://softwarecab.cab.unipd.it/proxydocile/proxydocile.xpi";
          };
          "{69856097-6e10-42e9-acc7-0c063550c7b8}" = ext "musescore-downloader";
          "uBlock0@raymondhill.net" = ext "ublock-origin";
          "@testpilot-containers" = ext "multi-account-containers";
          "@contain-facebook" = ext "facebook-container";
          "jid1-BoFifL9Vbdl2zQ@jetpack" = ext "decentraleyes";
          "jid1-KKzOGWgsW3Ao4Q@jetpack" = ext "i-dont-care-about-cookies";
          "{c0e1baea-b4cb-4b62-97f0-278392ff8c37}" = ext "behind-the-overlay-revival";
          # "{73a6fe31-595d-460b-a920-fcc0f8843232}" = ext "noscript";
        };
        PasswordManagerEnabled = false;
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
      };
    };
    profiles.default = {
      settings = {
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "devtools.debugger.remote-enabled" = true;
        "devtools.chrome.enabled" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.partition.network_state.ocsp_cache" = true;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.ping-centre.telemetry" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.hybridContent.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.discoverystream.sponsored-collections.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.search.suggest.enabled" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.showHome" = false;
        "extensions.pocket.site" = "";
        "browser.uidensity" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        #main-window {
          background: #f9f9faa5 !important;
        }
        .tab-background:is([selected], [multiselected]),
        .browser-toolbar:not(.titlebar-color) {
          background-color: #f9f9fa65 !important;
        }
      '';
    };

  };
  programs.git = {
    enable = true;
    userName = "DPDmancul";
    userEmail = "davide.peressoni@tuta.io";
    delta = {
      enable = true;
      options = {
        features = "interactive";
        wrap-max-lines = "unlimited";
        max-line-length = 2048;
        syntax-theme = "gruvbox-light";
      };
    };
    lfs.enable = true;
    ignores = [
      ".ccls-cache/"
      ".directory"
      "__pycache__"
      ".pytest_cache"
      ".owncloudsync.log"
      "._sync_*.db*"
    ];
    attributes = [
      "*.c     diff=cpp"
      "*.h     diff=cpp"
      "*.c++   diff=cpp"
      "*.h++   diff=cpp"
      "*.cpp   diff=cpp"
      "*.hpp   diff=cpp"
      "*.cc    diff=cpp"
      "*.hh    diff=cpp"
      "*.cs    diff=csharp"
      "*.css   diff=css"
      "*.html  diff=html"
      "*.xhtml diff=html"
      "*.ex    diff=elixir"
      "*.exs   diff=elixir"
      "*.go    diff=golang"
      "*.php   diff=php"
      "*.pl    diff=perl"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rb    diff=ruby"
      "*.rake  diff=ruby"
      "*.rs    diff=rust"
      "*.lisp  diff=lisp"
      "*.el    diff=lisp"
    ];
    extraConfig = {
      core.autoclrf = "input";
      init.defaultBranch = "main";
      status = {
        showUntrackedFiles = "all";
        submoduleSummary = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
      };
      pull = {
        ff = "only";
      };
      push = {
        autoSetupRemote = true;
      };
      protocol.version = 2;
    };
  };
  home.username = "dpd-";
  home.homeDirectory = "/home/dpd-";
  xdg.configFile."OpenTabletDriver/settings.json".source = ./tablet.json;
  home.stateVersion = "22.05";
  programs.fish = {
    enable = true;
    plugins = [
      {
        name = "base16-fish";
        src = pkgs.fetchFromGitHub {
          owner = "tomyun";
          repo = "base16-fish";
          rev = "2f6dd97";
          sha256 = "PebymhVYbL8trDVVXxCvZgc0S5VxI7I1Hv4RMSquTpA=";
        };
      }
      {
        name = "fish-colored-man";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-colored-man";
          rev = "1ad8fff";
          sha256 = "uoZ4eSFbZlsRfISIkJQp24qPUNqxeD0JbRb/gVdRYlA=";
        };
      }
    ];
    interactiveShellInit = ''
      fish_vi_key_bindings
      set fish_cursor_default block blink
      set fish_cursor_insert line blink
      set fish_cursor_replace_one underscore blink
      base16-gruvbox-light-medium
      set -x BAT_THEME gruvbox-light
      set -g man_blink -o red
      set -g man_bold -o green
      set -g man_standout -b cyan black
      set -g man_underline -o yellow
      if test $TERM = 'xterm-kitty'
        alias ssh 'kitty +kitten ssh'
      end
      set DISTRIBUTION (cat /etc/os-release | grep PRETTY | sed 's/PRETTY_NAME="\(.*\)"/\1/')
      set fish_greeting  (set_color green)$USER@(uname -n) (set_color yellow)(uname -srm) (set_color cyan)(uname -o) $DISTRIBUTION
    '';
  };
  programs.fish.shellAliases = {
  # environment.shellAliases = {
    df = "df -h"; # Human-readable sizes
    free = "free -m"; # Show sizes in MB
    gitu = "git add . && git commit && git push";
    nv = "nvim";
    mk = "make";
    nix-fish = "nix-shell --run fish";
    mkcd = ''mkdir -p "$argv"; and cd'';
    # cat = "bat";
    exa = "exa -G --color auto --icons -a -s type";
    ll = "exa -l --color always --icons -a -s type";
  };
  programs.starship = {
    enable = true;
    settings = {
      format = "╭─$all╰─$jobs$character";
      right_format = "$status";
      directory.home_symbol = "🏠"; # Nerd font variant: 
      status = {
        disabled = false;
        map_symbol = true;
      };
    };
  };
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;

      # do not create useless folders
      desktop = "$HOME";
      publicShare = "$HOME/.local/share/Public";
      templates = "$HOME/.local/share/Templates";
    };
    desktopEntries.nvim = {
      name = "NeoVim";
      genericName = "Text Editor";
      icon = "nvim";
      exec = "kitty nvim %F";
      terminal = false;
      categories = [ "Utility" "TextEditor" ];
      mimeType = [ "text/english" "text/plain" "text/x-makefile" "text/x-c++hdr" "text/x-c++src" "text/x-chdr" "text/x-csrc" "text/x-java" "text/x-moc" "text/x-pascal" "text/x-tcl" "text/x-tex" "application/x-shellscript" "text/x-c" "text/x-c++" ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = lib.zipAttrsWith
        (_: values: values)
        (let
          subtypes = type: program: subt:
            builtins.listToAttrs (builtins.map
              (x: {name = type + "/" + x; value = program; })
              subt);
        in [
          { "text/plain" = "nvim.desktop"; }
          { "text/html" = "firefox.desktop"; }
          (subtypes "x-scheme-handler" "firefox.desktop"
            [ "http" "https" "ftp" "chrome" "about" "unknown" ])
          (subtypes "aplication" "firefox.desktop"
            (map (ext: "x-extension-" + ext)
              [ "htm" "html" "shtml" "xhtml" "xht" ]
            ++ [ "xhtml+xml" ]))
          (subtypes "application" "writer.desktop"
            [
              "vnd.oasis.opendocument.text"
              "msword"
              "vnd.ms-word"
              "vnd.openxmlformats-officedocument.wordprocessingml.document"
              "vnd.oasis.opendocument.text-template"
            ])
          (subtypes "application" "calc.desktop"
            [
              "vnd.oasis.opendocument.spreadsheet"
              "vnd.ms-excel"
              "vnd.openxmlformats-officedocument.spreadsheetml.sheet"
              "vnd.oasis.opendocument.spreadsheet-template"
            ])
          (subtypes "application" "impress.desktop"
            [
              "vnd.oasis.opendocument.presentation"
              "vnd.ms-powerpoint"
              "vnd.openxmlformats-officedocument.presentationml.presentation"
              "vnd.oasis.opendocument.presentation-template"
            ])
          (subtypes "application" "libreoffice.desktop"
            [
              "vnd.oasis.opendocument.graphics"
              "vnd.oasis.opendocument.chart"
              "vnd.oasis.opendocument.formula"
              "vnd.oasis.opendocument.image"
              "vnd.oasis.opendocument.text-master"
              "vnd.sun.xml.base"
              "vnd.oasis.opendocument.base"
              "vnd.oasis.opendocument.database"
              "vnd.oasis.opendocument.graphics-template"
              "vnd.oasis.opendocument.chart-template"
              "vnd.oasis.opendocument.formula-template"
              "vnd.oasis.opendocument.image-template"
              "vnd.oasis.opendocument.text-web"
            ])
          { "inode/directory" = "nemo.desktop"; }
          (subtypes "application" "org.gnome.FileRoller.desktop"
            [ "zip" "rar" "7z" "x-tar" "x-gtar" "gnutar" ])
          { "application/pdf" = "okularApplication_pdf.desktop"; }
          { "image/vnd.djvu" = "okularApplication_pdf.desktop"; }
          { "image/x.djvu" = "okularApplication_pdf.desktop"; }
          (subtypes "image" "imv-folder.desktop"
            [ "png" "jpeg" "gif" "svg" "svg+xml" "tiff" "x-tiff" "x-dcraw" ])
          (subtypes "video" "umpv.desktop"
            [
              "avi" "msvideo" "x-msvideo"
              "mpeg" "x-mpeg" "mp4" "H264" "H265" "x-matroska"
              "ogg"
              "quicktime"
              "webm"
            ])
          (subtypes "audio" "umpv.desktop"
            [
              "aac" "flac"
              "mpeg" "mpeg3" # mp3
              "ogg" "vorbis" "opus" "x-opus+ogg"
              "wav" "x-wav"
              "audio/x-ms-wma"
            ])
          { "x-scheme-handler/tg" = "telegramdesktop.desktop"; }
        ]);
    };
  };
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
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gitlab.com" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-GitLab";
      };
      "github.com" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-GitHub";
      };
      "bitbucket.org" = {
        user         = "git";
        identityFile = "~/.ssh/dpd-BitBucket";
      };
      "aur.archlinux.org" = {
        user         = "aur";
        identityFile = "~/.ssh/aur";
      };
      dei = {
        hostname     = "login.dei.unipd.it";
        user         = "peressonid";
        identityFile = "~/.ssh/DEI";
      };
      capri = {
        proxyJump    = "dei";
        hostname     = "capri.dei.unipd.it";
        user         = "p1045u27";
        identityFile = "~/.ssh/DEI";
      };
      cloudveneto = {
        proxyJump    = "dei";
        hostname     = "147.162.226.106";
        port         = 2222;
        user         = "group11";
        identityFile = "~/.ssh/DEI";
      };
      nassuz = {
        hostname     = "10.10.10.10";
        user         = "admin";
        identityFile = "~/.ssh/nassuz";
      };
      pc3 = {
        hostname     = "10.10.10.10";
        port         = 822;
        user         = "cominfo";
      };
      nassuz_web = {
        hostname     = "lon1.tmate.io";
        user         = "cominfo/nassuz";
        identityFile = "~/.ssh/nassuz";
      };
    };
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
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      bars = [ { command = "${pkgs.waybar}/bin/waybar"; } ];
      gaps.inner = 5;
      colors.unfocused = let transparent = "#00000000"; in {
        background = "#222222";
        border = transparent;
        childBorder = transparent;
        indicator = "#292d2e";
        text = "#888888";
      };
      gaps.smartBorders = "on";
      modifier = "Mod4";
      input."*".xkb_layout = "eu";
      input."*".xkb_numlock = "enabled";
      terminal = "kitty";
      menu = ''wofi --show=drun -i --prompt=""'';
      floating.criteria = [
        { app_id = "firefox"; title = "^Firefox [-—] Sharing Indicator$"; }
        { app_id = "firefox"; title = "^Picture-in-Picture$"; }
        { app_id = "firefox"; title = "^Developer Tools [-—]"; }
        { app_id = "file-roller"; title = "Extract"; }
        { app_id = "file-roller"; title = "Compress"; }
        { app_id = "nemo"; title = "Properties"; }
        { app_id = "pavucontrol"; }
        { app_id = "qalculate-gtk"; }
      ];
      keybindings = lib.mkOptionDefault {
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
        "--locked XF86MonBrightnessDown" = "exec light -U 5";
        "--locked XF86MonBrightnessUp" = "exec light -A 5";
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
        "${modifier}+q" = "exec clipman pick -t wofi";
      };
    };
    extraConfig = ''
      exec ${wpaperd}/bin/wpaperd
      exec wl-paste -n -t text --watch clipman store >> /tmp/clipman-log.txt 2>&1 &
      exec wl-paste -n -p -t text --watch clipman store -P --histpath="~/.cache/clipman-primary.json" >> /tmp/clipman-log.txt 2>&1 &
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
  home.packages = with pkgs; [
    (writeShellScriptBin "dots" ''
      cd "${dotfiles}"
      nix-shell --run "make $*"
    '')
    (writeShellScriptBin "batt" ''
      ${bluetooth_battery}/bin/bluetooth_battery AC:12:2F:50:BB:3A
    '')
    wpaperd
    wofi
    swaylock-effects
    sway-contrib.grimshot
    wl-clipboard
    wl-clipboard-x11
    clipman
    polkit_gnome
    libreoffice
    cinnamon.nemo
    #pcmanfm lxmenu-data
    shared-mime-info
    (symlinkJoin {
      name = "file-roller";
      paths = [ gnome.file-roller ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/file-roller \
          --prefix PATH : "${writeShellScriptBin "gnome-terminal" ''"${kitty}/bin/kitty" $@''}/bin"
      '';
    })
    texlive.combined.scheme-full
    libsForQt5.okular
    diffpdf
    pdfmixtool
    xournalpp
    ocrmypdf tesseract
    # masterpdfeditor4
    calibre
    jmtpfs # For kindle
    pavucontrol # audio
    pamixer
    wdisplays   # screen
    imv
    gimp
    kolourpaint
    inkscape
    gnome.simple-scan
    mpv
    ffmpeg
    audacity
    lilypond # frescobaldi
    # denemo
    musescore
    (symlinkJoin {
      name = "fluidsynth";
      paths = [ fluidsynth ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/fluidsynth \
          --add-flags "${soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2"
      '';
    })
    qsynth
    handbrake
    mkvtoolnix
    shotcut
    # kdenlive
    losslesscut-bin
    obs-studio
    (tor-browser-bundle-bin.override {
      useHardenedMalloc = false;
    })
    clipgrab
    qbittorrent
    qalculate-gtk
    sqlitebrowser
    gnome.gnome-disk-utility
    baobab # disk usage
    tdesktop # Telegram
    simplenote
    ipscan
    # qemu
    cargo rustc clippy rustfmt
    gdb
    python3
    (agda.withPackages (p: [ p.standard-library ]))
  ];
  dconf.settings."org/cinnamon/desktop/applications/terminal".exec = "kitty";
  dconf.settings."org/cinnamon/desktop/default-applications/terminal".exec = "kitty";
  dconf.settings."org/nemo/desktop".show-desktop-icons = false;
}
