{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    plugins = with pkgs; with vimPlugins; [
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
              u = map ("<cmd>UndotreeToggle<cr>", "Undo tree"),
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
    ];
  };
}
