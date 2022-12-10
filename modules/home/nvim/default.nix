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
          require"mini.comment".setup()
          require"mini.surround".setup()
        '';
      }
    ];
  };

  appDefaultForMimes."nvim.desktop" = "text/plain";

  home.packages = with pkgs; [
    neovim-remote
  ];
}
