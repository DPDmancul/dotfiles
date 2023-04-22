{ config, pkgs, lib, ... }:
{
  programs.neovim = {
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
    '';
    plugins = with pkgs; with vimPlugins; [
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
    ];
  };

}
