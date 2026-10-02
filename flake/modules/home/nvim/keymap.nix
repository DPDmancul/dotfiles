{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    plugins = with pkgs; with vimPlugins; [
      {
        plugin = which-key-nvim;
        type = "lua";
        config = ''
          local wk = require "which-key"
          wk.add {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
            { "<leader>f", group = "Find"},
            { "<leader>fr", "<cmd>Telescope resume<cr>", desc = "Resume saerch" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
            { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
            { "<leader>fe", "<cmd>Telescope file_browser<cr>", desc = "Explore" },
            { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "File tree" },
            -- { "<leader>f\\", "<cmd>Telescope termfinder find<cr>", desc = "Terminals" },
            { "<leader>f:", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>fa", "<cmd>Telescope<cr>", desc = "All telescopes" },
            { "<leader>c", group = "Code" },
            { "<leader>ce", "<cmd>FeMaco<cr>", desc = "Edit fenced block" },
            { "<leader>g" , group = "Git" },
            { "<leader>gg", "<cmd>Lazygit<cr>", desc = "Lazygit" },
            { "<leader>r", group = "Reload" },
            { "<leader>rr", "<cmd>e<cr>", desc = "File" },
            { "<leader>rc", "<cmd>source ~/.config/nvim/init.vim<cr>", desc = "Config" },
            { "<leader>t", group = "Table" },
            { "<leader>tm", desc = "Toggle table mode" },
            { "<leader>tt", desc = "To table" },
            { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
            { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer right" },
            { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
            { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer left" },
            { "gb", "<cmd>BufferLinePick<cr>", desc = "Go to buffer" },
            { "gB", "<cmd>BufferLinePickClose<cr>", desc = "Close picked buffer" },
          }
        '';
      }
    ];
  };
}
