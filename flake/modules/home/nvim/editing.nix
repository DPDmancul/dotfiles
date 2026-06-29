{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    extraConfig = ''
      set whichwrap=b,s,h,l,<,>,[,] " Allow moving along lines when the start/end is reached
      set clipboard=unnamedplus     " Sync yank register with system clipboard
      set inccommand=nosplit        " incremental substitute preview
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
      inoremap <A-d> <c-r>=strftime('%Y-%m-%d')<cr>
      nnoremap <A-d> "=strftime('%Y-%m-%d')<cr>p
      inoremap <A-u> <c-r>=trim(system('uuidgen'))<cr>
      nnoremap <A-u> "=trim(system('uuidgen'))<cr>p
    '';
    plugins = with pkgs; with vimPlugins; [
      editorconfig-nvim
      vim-sleuth
      {
        plugin = camelcasemotion;
        config = "let g:camelcasemotion_key = '\\'";
        type = "viml";
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
        plugin = vim-suda;
        config = "let g:suda_smart_edit = 1";
        type = "viml";
      }
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require"nvim-autopairs".setup{}
        '';
      }
      unfree.vimPlugins.vim-table-mode
      {
        plugin = nvim-treesitter.withAllGrammars;
      }
      {
        plugin = rainbow-delimiters-nvim;
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''require"colorizer".setup{}'';
      }
      # {
      #   plugin = vimPlugins.nvim-FeMaco-lua;
      #   type = "lua";
      #   config = ''require"femaco".setup()'';
      # }
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

}
