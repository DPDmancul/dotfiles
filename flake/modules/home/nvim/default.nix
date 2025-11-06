{ config, pkgs, lib, ... }:
{
  imports = [
    ../xdg.nix
    ./ui.nix
    ./editing.nix
    ./keymap.nix
    ./lang.nix
    ./lsp.nix
  ];

  programs.neovim = {
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
    '';
    plugins = with pkgs; with vimPlugins; [
      plenary-nvim
      nvim-web-devicons
      telescope-file-browser-nvim
      telescope-fzf-native-nvim
      telescope-symbols-nvim
      (vimUtils.buildVimPlugin {
        name = "project-nvim";
        src = fetchFromGitHub {
          owner = "DrKJeff16";
          repo = "project.nvim";
          rev = "deaec4c3606ade11f6ae89b4e9576065b3140d0e";
          sha256 = "VYOABmvydOHu7EM8n1EQ+Le1NOtZIcaSjwW4x8uhNQI=";
        };
      })
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require"project".setup()

          local telescope = require "telescope"
          telescope.load_extension("file_browser")
          telescope.load_extension("projects")
          telescope.load_extension("fzf")
        '';
      }
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''require"gitsigns".setup()'';
      }
      {
        plugin = mini-nvim;
        type = "lua";
        config = ''
          require"mini.surround".setup()
          require"mini.indentscope".setup()
          require"mini.bufremove".setup()
          vim.api.nvim_create_user_command('Bdelete', function(args)
            MiniBufremove.delete(tonumber(args.args), args.bang)
          end, { bang = true, addr = 'buffers', nargs = '?' })
          vim.api.nvim_set_keymap('c', 'bd', 'Bdelete', {noremap = true})
        '';
      }
    ];
  };

  appDefaultForMimes."nvim.desktop" = "text/plain";

  home.packages = with pkgs; [
    neovim-remote
  ];
}
